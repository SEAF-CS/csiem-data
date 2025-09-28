def import_wamsi_wwmsp4_zoop(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates):
    import pandas as pd
    import numpy as np
    import os
    import sys
    sys.path.append(str(CODE_DIR))
    from import_py.utils.matlab_utils import get_datapath_from_matlab, get_conversion_data, get_variable_names, get_site_coordinates

    # specify constants (mirroring WWMSP4 ROMS style)
    AGENCY_NAME = "Western Australian Marine Science Institution"
    AGENCY_CODE = "WAMSI"
    PROGRAM = "WWMSP4"
    PROJECT = "Zooplankton"
    STATION_STATUS = "Active"
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
    print(f"Current datapath: {datapath}")

    # Directories analogous to your existing importer
    dir_lst = [
        datapath + "/data-lake/WAMSI/WWMSP4/WWMSP4_zoop/",
    ]
    dir_header = [
        datapath + "/data-warehouse/csv/wamsi/wwmsp4/zooplankton2",
    ]
    dir_header_raw = [
        datapath_raw + "/data-warehouse/csv/wamsi/wwmsp4/zooplankton2",
    ]
    dataset = "wwmsp4"
    wamsi_data = get_conversion_data(dataset, matlab_data_conversion_data)
    site_dataset = "wwmsp4"
    site_coordinates_data = get_site_coordinates(site_dataset, matlab_data_site_coordinates)    


    def process_data(dir):
        # 1) Pick first .xlsx and read the fixed layout for FINAL-20250911
        excel_file = "Westport Zooplankton biovolume mm3_m3 and biomass_20250911.xlsx"
        table = pd.read_excel(os.path.join(dir, excel_file),
                              sheet_name="FINAL-20250911",
                              engine="openpyxl",
                              header=None)
        
        # Fixed indices (0-based) for this sheet
        site_row   = 57
        date_row   = 58
        start_col, end_col = 0, 183
        var_row_start = 61
        var_row_end   = table.shape[0] - 1

        # Sites and dates
        sites = table.iloc[site_row, start_col:end_col+1].astype(str).str.strip().tolist()
        s = table.iloc[date_row, start_col:end_col+1].astype(str).str.strip()
        s = s.where(~s.str.upper().str.startswith('DATE'), None)
        dates = pd.to_datetime(s, errors='coerce')

        # 2) Build normalized records: ['SiteAED','Date','Depth','VarOld','Value']
        records = []
        for r in range(var_row_start, var_row_end+1):
            varname = table.iat[r, 1]  # Column B
            if pd.isna(varname) or str(varname).strip() == "":
                continue
            varname = str(varname).strip()
            for offset, site_id in enumerate(sites):
                c = start_col + offset
                v = table.iat[r, c]
                try:
                    v = float(v)
                except Exception:
                    v = np.nan
                if np.isnan(v):
                    continue
                dt = dates.iloc[offset] if offset < len(dates) else pd.NaT
                if pd.isna(dt):
                    continue
                records.append({
                    "SiteAED": str(site_id).split(" ")[0],
                    "Date":    pd.to_datetime(dt),
                    "Depth":   1.0,
                    "VarOld":  varname,
                    "Value":   v,
                })
        df = pd.DataFrame.from_records(records, columns=["SiteAED","Date","Depth","VarOld","Value"])
       # Convert Date to string in "yyyy-mm-dd HH:MM:SS" format
        df['Date'] = pd.to_datetime(df['Date'], errors='coerce')
        df['Date'] = df['Date'].dt.strftime("%Y-%m-%d %H:%M:%S")

      # 3) Map VarOld -> (Conv, Id) using agency.wwmsp4 from the MATLAB structs already loaded
      #    (same style as your ROMS code: iterate fields of the MATLAB struct)
      # Expecting globals: matlab_data_conversion_data, matlab_data_variable_names
        wamsi_prog = wamsi_data

      # Output dir 
        output_dir = os.path.join(datapath,"data-warehouse", "csv", "wamsi", "wwmsp4", "zooplankton2") 
        os.makedirs(output_dir, exist_ok=True)
       

       # DataFrame to return (Id, Name)
        all_var_info = pd.DataFrame(columns=['Id', 'Name'])

         # 4) Write one _DATA per (SiteAED, VarOld)
        for (site_id, var_old), g in df.groupby(["SiteAED", "VarOld"]):
        # Find conversion and Id in agency.wwmsp4 by exact Old match
        
          conv_factor = 1.0
          Id = None
          for field in wamsi_prog.dtype.names:
            # skip if Old empty
            if wamsi_prog[field][0,0]['Old'][0,0].size == 0:
                continue
            old_name = wamsi_prog[field][0,0]['Old'][0,0][0]
            if old_name == var_old:

                conv_factor = float(wamsi_prog[field][0,0]['Conv'][0,0][0])
                Id = wamsi_prog[field][0,0]['ID'][0,0][0]
                break
          

         # Resolve canonical variable name from varkey
          name_conv = get_variable_names(Id, matlab_data_variable_names)['Name'][0,0][0]

          # Prepare DATA frame like your ROMS writer
          out = g.loc[:, ["Date","Depth","Value"]].copy()
          out["Data"] = pd.to_numeric(out["Value"], errors="coerce") * conv_factor
          out["QC"] = "N"
          out = out.loc[:, ["Date","Depth","Data","QC"]].sort_values("Date")

         # File name: <Site>_<VarName>_DATA.csv
          filevar = str(name_conv).replace(" ", "_")
          output_filename = f"{dataset}_{site_id}_{filevar}_DATA.csv"
          out.to_csv(os.path.join(output_dir, output_filename), index=False)
          

         # Append to the var info table (same shape you returned before)
          all_var_info = pd.concat(
            [all_var_info, pd.DataFrame({"Id": [Id], "Name": [name_conv]})],
            ignore_index=True
         )
          

        return all_var_info
    
    def process_header(dir_header,var_id_name_df,dir_header_raw):
        for file in os.listdir(dir_header):
            if file.endswith("_DATA.csv") and file.startswith("wwmsp4") and not file.startswith("._"):
                print(f"Datafile: {file}")

                # Extract the National Station ID from the filename
                # Example: wwmsp4_CS6_Acartiidae_DATA.csv
                # NATIONAL_STATION_ID = "CS6"
                NATIONAL_STATION_ID = "_".join(file.split("_")[0:2])
                if "polygon" in NATIONAL_STATION_ID:
                    NATIONAL_STATION_ID = NATIONAL_STATION_ID.replace("polygon","POLYGON")
                print(f"NATIONAL_STATION_ID: {NATIONAL_STATION_ID}")

                # Lookup station metadata from MATLAB-style site_coordinates_data
                site_coordinates = site_coordinates_data[NATIONAL_STATION_ID][0,0]
                SITE_DESCRIPTION = site_coordinates["Description"][0,0][0]
                LAT = site_coordinates["Lat"][0,0][0][0]
                LONG = site_coordinates["Lon"][0,0][0][0]
                # Build a tag using agency code, program and folder name
                TAG =  AGENCY_CODE + "-" + PROGRAM + "-" + "ZOOP"
                # Find the Variable ID in var_id_name_df (pandas DataFrame mapping Name → Id)
                VARIABLE = " ".join(file.split("_")[2:-1])
                print(VARIABLE)
                VARIABLE_ID = var_id_name_df.loc[var_id_name_df["Name"] == VARIABLE, "Id"].iloc[0]
                print(f"VARIABLE_ID: {VARIABLE_ID}")

                # Construct the header key–value dictionary
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
                "Variable ID": VARIABLE_ID,
                # Category comes from MATLAB variable name lookup
                "Data Category": get_variable_names(VARIABLE_ID, matlab_data_variable_names)['Category'][0,0][0],
                "Sampling Rate (min)": SAMPLING_RATE,
                "Date": DATE,
                "Depth": DEPTH,
                "Variable": VARIABLE,
                "QC": QC
                 }
                # Create the HEADER filename by replacing DATA → HEADER
                output_filename = file.replace("DATA","HEADER")
                print(output_filename)
                file_path = os.path.join(dir_header, output_filename)
                # Write a two-column CSV (Header, Value) without column names
                header_df = pd.DataFrame({"Header": header_dict.keys(), "Value": header_dict.values()})
                header_df.to_csv(file_path, index=False, header=False)
                print(f"Headerfile: {file_path}")


    var_id_name_df = []
    for dir in dir_lst:
        data_df = process_data(dir)
        var_id_name_df.append(data_df)
        

    
    for i in range(len(dir_header)):
        process_header(dir_header[i],var_id_name_df[i],dir_header_raw[i])          


    