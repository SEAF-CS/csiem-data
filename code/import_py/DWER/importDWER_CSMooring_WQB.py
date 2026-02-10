def import_dwer_csmooring_WQB(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates):
    import pandas as pd
    import numpy as np
    import os
    import sys
    import time
    sys.path.append(str(CODE_DIR))
    from import_py.utils.matlab_utils import get_datapath_from_matlab, get_conversion_data, get_variable_names, get_site_coordinates

    # specify constants 
    AGENCY_NAME = "Department of Water and Environmental Regulation"
    AGENCY_CODE = "DWER"
    PROGRAM = "CSMOORING"
    PROJECT = "csmooring"
    STATION_STATUS = "Inactive"
    TIME_ZONE = "GMT +8"
    VERT_DATUM = "mAHD" 
    DEPLOYMENT = "Floating"
    DEPLOYMENT_POSITION = "1.0m below Surface"
    VERT_REF = "m below Surface"
    SITE_MEAN_DEPTH = ""
    BAD_VALUE = 'NaN'
    EMAIL = "Santiago <00114911@uwa.edu.au>"
    SAMPLING_RATE = "/day"
    DATE = "yyyy-mm-dd HH:MM:SS"
    DEPTH = "Decimal"
    QC = "NaN"

    # Resolve datapaths from your MATLAB config
    datapath, datapath_raw = get_datapath_from_matlab(ACTIONS_DIR, base_path)
    if isinstance(datapath_raw, str) and ":\\" in datapath_raw:
        drive = datapath_raw[0].lower()
        remainder = datapath_raw[2:].lstrip("\\/").replace("\\", "/")
        wsl_path = f"/mnt/{drive}/{remainder}"
        # Only translate to /mnt/<drive> when running under WSL.
        if sys.platform.startswith("linux") and os.path.exists(f"/mnt/{drive}"):
            datapath = wsl_path
    print(f"Current datapath: {datapath}")

    # Directories analogous to your existing importer
    dir_lst = [
        datapath + "/data-lake/DWER/CSMOORING/B-20250715/Cockburn Mooring Data",
    ]
    dir_header = [
        datapath + "/data-warehouse/csv/dwer/csmooring/B/",
    ]
    dir_header_raw = [
        os.path.join(datapath_raw, "data-warehouse/csv/dwer/csmooring/B/"),
    ]
    dataset = "dwer"
    run_start = time.time()
    agency_data = get_conversion_data(dataset, matlab_data_conversion_data)
    site_dataset = "dwermooring"
    site_coordinates_data = get_site_coordinates(site_dataset, matlab_data_site_coordinates)    


    def process_data(dir):
        def matlab_str(value):
            if isinstance(value, str):
                return value
            if isinstance(value, bytes):
                return value.decode('utf-8', errors='ignore')
            if isinstance(value, np.ndarray):
                if value.size == 0:
                    return ''
                return matlab_str(value.flat[0])
            return str(value)

        known_variables = set()
        for field in agency_data.dtype.names:
            entry = agency_data[field][0,0]
            old_name = matlab_str(entry['Old'])
            if old_name:
                known_variables.add(old_name)

        records = []
        file_path = os.path.join(dir, "EXO_DataBase_QCed_Level2_combined_FINAL.csv")
        if not os.path.exists(file_path):
            return pd.DataFrame(columns=['Id', 'Name'])

        tab = pd.read_csv(file_path, dtype=str, encoding="utf-8", encoding_errors="replace", low_memory=False)
        if tab.empty:
            return pd.DataFrame(columns=['Id', 'Name'])
        tab.columns = [str(col).replace("\ufeff", "").strip() for col in tab.columns]

        time_col = "Timestamp"
        depth_col = "Sample Depth (m)"
        site_number_col = "Site Number"
        if time_col not in tab.columns:
            return pd.DataFrame(columns=['Id', 'Name'])

        time_values = pd.to_datetime(tab[time_col], errors="coerce", dayfirst=True)
        depth_values = pd.to_numeric(tab[depth_col], errors="coerce") if depth_col in tab.columns else pd.Series(np.nan, index=tab.index)
        site_numbers = tab[site_number_col].astype(str).str.strip() if site_number_col in tab.columns else pd.Series("", index=tab.index)
        site_ids = site_dataset + site_numbers

        var_columns = [
            "Water Temp (°C)",
            "Salinity (ppt)",
            "Diss Oxy (mg/l)",
            "Turbidity (NTU)",
            "pH in-situ (pH)",
            "Chl a (µg/L)",
            "fDOM (RFU)",
        ]

        for col_name in var_columns:
            if col_name not in tab.columns:
                continue
            if col_name not in known_variables:
                continue
            data_values = pd.to_numeric(tab[col_name], errors="coerce")
            df_var = pd.DataFrame({
                "SiteAED": site_ids,
                "Date": time_values,
                "Depth": depth_values,
                "VarOld": col_name,
                "Value": data_values,
            })
            df_var = df_var.dropna(subset=["Date", "Value"])
            records.extend(df_var.to_dict(orient="records"))

        df = pd.DataFrame.from_records(records, columns=["SiteAED","Date","Depth","VarOld","Value"])
        if df.empty:
            return pd.DataFrame(columns=['Id', 'Name'])

        df['Date'] = pd.to_datetime(df['Date'], errors='coerce')
        df = df.dropna(subset=['Date'])
        df['Date'] = df['Date'].dt.strftime("%Y-%m-%d %H:%M:%S")

      # 3) Map VarOld -> (Conv, Id) using agency data from the MATLAB structs already loaded
      #    (same style as your ROMS code: iterate fields of the MATLAB struct)
      # Expecting globals: matlab_data_conversion_data, matlab_data_variable_names
        agency_prog = agency_data

      # Output dir 
        output_dir = os.path.join(datapath,"data-warehouse", "csv", "dwer", "csmooring", "B") 
        os.makedirs(output_dir, exist_ok=True)
       

       # DataFrame to return (Id, Name)
        all_var_info = pd.DataFrame(columns=['Id', 'Name'])

         # 4) Write one _DATA per (SiteAED, VarOld)
        for (site_id, var_old), g in df.groupby(["SiteAED", "VarOld"]):
        # Find conversion and Id in agency.wwmsp4 by exact Old match
        
          conv_factor = 1.0
          Id = None
          for field in agency_prog.dtype.names:
            # skip if Old empty
            if agency_prog[field][0,0]['Old'][0,0].size == 0:
                continue
            old_name = agency_prog[field][0,0]['Old'][0,0][0]
            if old_name == var_old:

                conv_factor = float(agency_prog[field][0,0]['Conv'][0,0][0])
                Id = agency_prog[field][0,0]['ID'][0,0][0]
                break
          

         # Resolve canonical variable name from varkey
          if Id is None:
              print(f"Skipping {site_id} {var_old}: variable not found in key.")
              continue
          name_conv = str(get_variable_names(Id, matlab_data_variable_names)['Name'][0,0][0]).strip()

          # Prepare DATA frame like your ROMS writer
          out = g.loc[:, ["Date","Depth","Value"]].copy()
          out["Data"] = pd.to_numeric(out["Value"], errors="coerce") * conv_factor
          out["QC"] = "N"
          out = out.loc[:, ["Date","Depth","Data","QC"]].sort_values("Date")

         # File name: <Site>_<VarName>_DATA.csv
          filevar = str(name_conv).replace(" ", "_")
          output_filename = f"{site_id}_{filevar}_WQB_DATA.csv"
          out.to_csv(os.path.join(output_dir, output_filename), index=False)
          

         # Append to the var info table (same shape you returned before)
          all_var_info = pd.concat(
            [all_var_info, pd.DataFrame({"Id": [Id], "Name": [name_conv]})],
            ignore_index=True
         )
          

        return all_var_info
    
    def process_header(dir_header,var_id_name_df,dir_header_raw):
        for f loile in os.listdir(dir_header):
            if not (file.endswith("_DATA.csv") and file.startswith("dwermooring") and not file.startswith("._")):
                continue

            file_path_data = os.path.join(dir_header, file)
            if os.path.getmtime(file_path_data) < run_start:
                continue
            print(f"Datafile: {file}")

            name_parts = os.path.splitext(file)[0].split("_")
            if len(name_parts) < 2:
                print(f"Skipping {file}: unexpected filename format.")
                continue

            site_id = name_parts[0]
            variable_name = " ".join(name_parts[1:-1]).replace("_", " ").replace(" WQB", "").strip()
            NATIONAL_STATION_ID = site_id
            if NATIONAL_STATION_ID not in site_coordinates_data.dtype.names:
                print(f"Skipping {file}: site {NATIONAL_STATION_ID} not found in site key.")
                continue

            site_coordinates = site_coordinates_data[NATIONAL_STATION_ID][0,0]
            SITE_DESCRIPTION = site_coordinates["Description"][0,0][0]
            LAT = site_coordinates["Lat"][0,0][0][0]
            LONG = site_coordinates["Lon"][0,0][0][0]
            TAG =  AGENCY_CODE + "-" + "CSMOORING"+ "-" +"WQB"

            match = var_id_name_df.loc[var_id_name_df["Name"].astype(str).str.strip() == variable_name, "Id"]
            if match.empty:
                print(f"Skipping {file}: variable {variable_name} not found.")
                continue
            VARIABLE = match.iloc[0]

            header_dict = {
                "Agency Name": AGENCY_NAME,
                "Agency Code": AGENCY_CODE,
                "Program": PROGRAM,
                "Project": PROJECT,
                "Tag": TAG,
                "Data File Name": file,
                "Location": dir_header_raw,
                "Station Status": STATION_STATUS,
                "Lat": LAT,
                "Long": LONG,
                "Time Zone": TIME_ZONE,
                "Vertical Datum": VERT_DATUM,
                "National Station ID": NATIONAL_STATION_ID,
                "Site Description": SITE_DESCRIPTION,
                "Deployment": DEPLOYMENT,
                "Deployment Position": DEPLOYMENT_POSITION,
                "Vertical Reference": VERT_REF,
                "Site Mean Depth": SITE_MEAN_DEPTH,
                "Bad or Unavailable Data Value": BAD_VALUE,
                "Contact Email": EMAIL,
                "Variable ID": VARIABLE,
                "Data Category": get_variable_names(VARIABLE, matlab_data_variable_names)['Category'][0,0][0],
                "Sampling Rate (min)": SAMPLING_RATE,
                "Date": DATE,
                "Depth": DEPTH,
                "Variable": variable_name,
                "QC": QC
            }

            output_filename = file.replace("DATA","HEADER")
            print(output_filename)
            file_path = os.path.join(dir_header, output_filename)
            header_df = pd.DataFrame({"Header": header_dict.keys(), "Value": header_dict.values()})
            header_df.to_csv(file_path, index=False, header=False)
            print(f"Headerfile: {file_path}")


    var_id_name_df = []
    for dir in dir_lst:
        data_df = process_data(dir)
        var_id_name_df.append(data_df)

    for i in range(len(dir_header)):
        process_header(dir_header[i],var_id_name_df[i],dir_header_raw[i])
