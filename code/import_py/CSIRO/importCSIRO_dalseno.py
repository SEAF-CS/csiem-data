def import_csiro_dalseno(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates):
    import pandas as pd
    import numpy as np
    import os
    import sys
    sys.path.append(str(CODE_DIR))
    from import_py.utils.matlab_utils import get_datapath_from_matlab, get_conversion_data, get_variable_names, get_site_coordinates

    # specify constants for headers
    AGENCY_NAME = "Commonwealth Scientific and Industrial Research Organisation"
    AGENCY_CODE = "CSIRO"
    PROGRAM = "DALSENO"
    PROJECT = "Dalseno et al (2024) https://doi.org/10.1016/j.rsma.2024.103738"
    STATION_STATUS = "Completed"
    TIME_ZONE = "GMT +8"
    VERT_DATUM = "mAHD"
    DEPLOYMENT = "Fixed"
    DEPLOYMENT_POSITION = "0.4m above Seabed"
    VERT_REF = "m above Seabed"
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
        datapath + "/data-lake/CSIRO/Dalseno/",
    ]
    dir_header = [
        datapath + "/data-warehouse/csv/csiro/dalseno",
    ]
    dir_header_raw = [
        datapath_raw + "/data-warehouse/csv/csiro/dalseno",
    ]
# Ensure output directories exist
    for target in dir_header:
        os.makedirs(target, exist_ok=True)

    dataset = "CSIRO"
    wamsi_data = get_conversion_data(dataset, matlab_data_conversion_data)
    site_dataset = "CSIRO"
    site_coordinates_data = get_site_coordinates(site_dataset, matlab_data_site_coordinates)    


    def process_data(dir):
        print(f"[DEBUG] entrando a process_data con dir={dir}")
        # 1) Pick first .xlsx and read the fixed layout for Dalseno.xlsx
        excel_file = "Dalseno.xlsx"
        site_sheet = pd.read_excel(
            os.path.join(dir, excel_file),
            sheet_name="SITES",
            engine="openpyxl",
            header=None,
        )
        print(f"[DEBUG] shape SITES: {site_sheet.shape}")
        print(site_sheet.head(10))
        site_value = str(site_sheet.iat[3, 0]).strip()  # "CS13" en A4
        print(f"[DEBUG] site_value: {site_value}")
        site_id = site_value.split()[0] if site_value else ""
        print(f"[DEBUG] site_id: {site_id}")
        

        table = pd.read_excel(
            os.path.join(dir, excel_file),
            sheet_name="JOINED",
            engine="openpyxl",
            header=None,
        )
        print(f"[DEBUG] shape JOINED: {table.shape}")
        print(table.head(15))

        date_row = table.index[
            table.iloc[:, 1].astype(str).str.contains("DATE", case=False, na=False)
        ][0]
        print(f"[DEBUG] date_row encontrado: {date_row}")
        start_col = 2
        var_row_start = date_row + 1
        var_row_end = table.index[table.iloc[:, start_col].notna()][-1]
        print(f"[DEBUG] rango de filas con datos: {var_row_start}–{var_row_end}")

        var_label = str(table.iat[date_row, start_col]).strip()
        print(f"[DEBUG] var_label: {var_label}")


        # 2) Build normalized records: ['SiteAED','Date','Depth','VarOld','Value']
        records = []
        for r in range(var_row_start, var_row_end + 1):
            dt = pd.to_datetime(table.iat[r, 1], errors="coerce")
            value = pd.to_numeric(table.iat[r, start_col], errors="coerce")
            if pd.isna(dt) or np.isnan(value):
                continue
            records.append({
                "SiteAED": site_id,
                "Date": dt,
                "Depth": 0.4,  # fixed depth above seabed
                "VarOld": var_label,
                "Value": value,
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
        output_dir = dir_header[0]
        os.makedirs(output_dir, exist_ok=True)

        # DataFrame to return (Id, Name)
        all_var_info = pd.DataFrame(columns=['Id', 'Name'])

        # 4) Write one _DATA per (SiteAED, VarOld)
        for (site_id, var_old), g in df.groupby(['SiteAED', 'VarOld']):
            # Find conversion and Id in agency.wwmsp4 by exact Old match
            conv_factor = 1.0
            Id = None
            for field in wamsi_prog.dtype.names:
                # skip if Old empty
                if wamsi_prog[field][0,0]['Old'][0,0].size == 0:
                    continue
                old_name = wamsi_prog[field][0,0]['Old'][0,0][0]
                if isinstance(old_name, bytes):
                    old_name = old_name.decode('utf-8')
                if old_name == var_old:
                    conv_factor = float(wamsi_prog[field][0,0]['Conv'][0,0][0])
                    Id = wamsi_prog[field][0,0]['ID'][0,0][0]
                    break

            # Resolve canonical variable name from varkey
            if Id is None:
                print(f"Skipping variable {var_old} - no conversion mapping")
                continue
            name_conv = get_variable_names(Id, matlab_data_variable_names)['Name'][0,0][0]

            # Prepare DATA frame like your ROMS writer
            out = g.loc[:, ['Date', 'Depth', 'Value']].copy()
            out['Data'] = pd.to_numeric(out['Value'], errors='coerce') * conv_factor
            out['QC'] = 'N'
            out = out.loc[:, ['Date', 'Depth', 'Data', 'QC']].sort_values('Date')

            # File name: <Site>_<VarName>_DATA.csv
            filevar = str(name_conv).replace(' ', '_')
            output_filename = f"{dataset}_{site_id}_{filevar}_DATA.csv"
            out.to_csv(os.path.join(output_dir, output_filename), index=False)

            # Append to the var info table (same shape you returned before)
            all_var_info = pd.concat(
                [all_var_info, pd.DataFrame({'Id': [Id], 'Name': [name_conv]})],
                ignore_index=True
            )

        return all_var_info
    
    def process_header(dir_header,var_id_name_df,dir_header_raw):
        print(f"[DEBUG] entrando a process_header con dir_header={dir_header}")
        print(f"[DEBUG] archivos encontrados: {os.listdir(dir_header)}")
        for file in os.listdir(dir_header):
            if file.endswith("_DATA.csv") and file.startswith(dataset) and not file.startswith("._"):
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
                TAG =  AGENCY_CODE + "-" + PROGRAM 
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


    
