def import_uwa_cwr(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates):
    import pandas as pd
    import numpy as np
    import os
    import sys
    sys.path.append(str(CODE_DIR))
    from import_py.utils.matlab_utils import get_datapath_from_matlab, get_conversion_data, get_variable_names, get_site_coordinates

    # specify constants
    AGENCY_NAME = "The University of Western Australia"
    AGENCY_CODE = "UWA"
    PROGRAM = "Centre for Water Research (CWR)"
    PROJECT = "Southern Metropolitan Coastal Waters Study (SMCWS)" 
    STATION_STATUS = "Active"
    TIME_ZONE = "GMT +8"
    VERT_DATUM = "mAHD"
    DEPLOYMENT = "Profile"
    DEPLOYMENT_POSITION = "m below Surface"
    VERT_REF = "Water Surface"
    SITE_MEAN_DEPTH = ""
    BAD_VALUE = 'NaN'
    EMAIL = "Yvette <00114814@uwa.edu.au>"
    SAMPLING_RATE = ""
    DATE = "yyyy-mm-dd HH:MM:SS"
    DEPTH = "Decimal"
    QC = "NaN"

    datapath,datapath_raw = get_datapath_from_matlab(ACTIONS_DIR,base_path)
    print(f"Current datapath: {datapath}")

    dir_lst = [
        datapath + "/data-lake/UWA/CWR/cwrctd"
    ]
    dir_header = [
        datapath + "/data-warehouse/csv/uwa/cwr/cwrctd"
    ]
    dir_header_raw = [
        datapath_raw + "/data-warehouse/csv/uwa/cwr/cwrctd"
    ]

    dataset = "UWA"
    uwa_data = get_conversion_data(dataset,matlab_data_conversion_data)
    site_dataset = "UWA"
    site_coordinates_data = get_site_coordinates(site_dataset,matlab_data_site_coordinates)

    def process_data(dir):
        # Initialize the DataFrame to store all variable information
        all_var_info = pd.DataFrame(columns=['Id', 'Name'])

        all_data = {}  # Dictionary to store data for each sitecode and variable

        for file in os.listdir(dir):
            if file.endswith(".csv") and not file.startswith("._"):
                df = pd.read_csv(os.path.join(dir, file), header=0)
                df['Date'] = pd.to_datetime(df['DATE'], format='%Y%m%d %H:%M:%S')
                df['Date'] = df['Date'].dt.strftime('%Y-%m-%d %H:%M:%S')
                df = df.dropna(how='all')
                df['SITECODE'] = df['SITECODE'].str.upper().str.replace("?", "").str.replace("/","").str.replace(".","dp")
                sitecode_lst = df['SITECODE'].unique().tolist()
                df['LOCATION'] = df['LOCATION'].str.lower()
                # Replace 'EPA COCKBURN S' with 'EPA COCKBURN' in the 'LOCATION' column
                df['LOCATION'] = df['LOCATION'].replace('epa cockburn s', 'epa cockburn', regex=False)
                df = df[['Date','SITECODE','TEMPERATURE (C)','SALINITY (pss)','DENSITY (kgm-3)','CONDUCTIVITY (sm)','VELOCITY (ms-1)','DEPTH (m)','LOCATION']]
                
                var_lst = df.columns.to_list()
                variables = [var for var in var_lst if var not in ['Date', 'SITECODE', 'DEPTH (m)', 'LOCATION']]
                for sitecode in sitecode_lst:
                    df_sitecode = df[df['SITECODE'] == sitecode]
                    location = df_sitecode['LOCATION'].iloc[0]
                    for variable in variables:
                        df_filtered = pd.DataFrame()

                        df_filtered['Date'] = df_sitecode['Date']
                        df_filtered['Data'] = df_sitecode[variable]
                        df_filtered['Variable'] = variable
                        df_filtered['Depth'] = df_sitecode['DEPTH (m)']
                        df_filtered['QC'] = 'N'

                        df_filtered.replace("", np.nan, inplace=True)

                        # Find matching variable in MATLAB data and get conversion factor
                        conv_factor = 1  # default value
                        for field in uwa_data.dtype.names:
                            # print(f"Field: {field}")
                            # Skip if the field's 'Old' value is empty
                            if uwa_data[field][0, 0]['Old'][0,0].size == 0:
                                continue
                            old_name = uwa_data[field][0, 0]['Old'][0, 0][0]
                            if old_name == variable:
                                conv_factor = float(uwa_data[field][0, 0]['Conv'][0, 0][0])
                                Id = uwa_data[field][0, 0]['ID'][0, 0][0]
                                break

                        # Convert value of different units
                        if conv_factor != 1:
                            df_filtered['Data'] = pd.to_numeric(df_filtered['Data'], errors='coerce')  # Convert non-numeric values to NaN
                            df_filtered['Data'] *= conv_factor

                        df_filtered = df_filtered.dropna(subset=['Data'])
                        # Drop rows where 'Data' is NaN using pd.isna()
                        df_filtered = df_filtered[~pd.isna(df_filtered['Data'])]

                        name_conv = get_variable_names(Id,matlab_data_variable_names)['Name'][0, 0][0]
                        # Append to the all_var_info DataFrame
                        var_info = pd.DataFrame({
                            'Id': [Id],
                            'Name': [name_conv]
                        })
                        all_var_info = pd.concat([all_var_info, var_info], ignore_index=True)

                        # Convert 'Data' to numeric, replacing non-numeric values with NaN
                        df_filtered['Data'] = pd.to_numeric(df_filtered['Data'], errors='coerce')
                        
                        # Remove rows where 'Data' is NaN
                        df_filtered = df_filtered.dropna(subset=['Data'])
                        
                        # Additional check: remove rows with infinite values
                        df_filtered = df_filtered[~np.isinf(df_filtered['Data'])]
                        
                        if variable.lower() == 'salinity (pss)':
                            df_filtered = df_filtered[df_filtered['Data'] <= 100000000000000]

                        df_filtered = df_filtered.loc[:, ["Date", "Depth", "Data", "QC"]]
                        file_name = file.split('_EPSG7844')[0].split('CTD_')[1]
                        key = (file_name, location, sitecode, variable,name_conv)
                        if key not in all_data:
                            all_data[key] = df_filtered
                        else:
                            all_data[key] = pd.concat([all_data[key], df_filtered], ignore_index=True)

        # Now process and save the concatenated data
        for (file_name, location, sitecode, variable,name_conv), df_filtered in all_data.items():
            output_dir = dir.replace("data-lake","data-warehouse/csv")
            SPLIT = output_dir.split("data-warehouse/csv")
            output_dir = "data-warehouse/csv".join([SPLIT[0],SPLIT[1].lower()])
            os.makedirs(output_dir, exist_ok=True)

            output_filename = f'py_{file_name.replace("_","")}_{sitecode}_{name_conv.replace(" ","_")}_DATA.csv'.replace("/","")
            print(output_dir)
            print(output_filename)
            df_filtered = df_filtered.sort_values(by=['Date', 'Depth'])
            df_filtered = df_filtered.drop_duplicates(keep='first')
            print(df_filtered)
            
            # Check if all 'Data' values are NaN
            if not df_filtered.empty and not df_filtered['Data'].isna().all():
                df_filtered.to_csv(os.path.join(output_dir, output_filename), index=False)
            else:
                print(f"Skipping {output_filename} as all 'Data' values are NaN")
    
        return all_var_info  # Return the DataFrame containing variable IDs and names
    
    def process_header(dir_header,var_id_name_df,dir_header_raw):
        for file in os.listdir(dir_header):
            if file.endswith('_DATA.csv') and file.startswith("py") and not file.startswith("._"):
                print(f"Datafile: {file}")

                NATIONAL_STATION_ID = file.split("_")[2]
                SITE_DESCRIPTION = file.split("_")[1]
                print(file)
                print(NATIONAL_STATION_ID)

                site_coordinates = site_coordinates_data[f'uwa_{NATIONAL_STATION_ID}'][0,0]
                LAT = round(site_coordinates["Lat"][0,0][0][0], 4)
                LONG = round(site_coordinates["Lon"][0,0][0][0], 4)
            
                TAG = AGENCY_CODE + "-" + PROGRAM.split("(")[1].strip(")") + "-" + PROJECT.split("(")[1].strip(")")

                VARIABLE = " ".join(file.split("_")[3:-1])
                VARIABLE_ID = var_id_name_df.loc[var_id_name_df["Name"] == VARIABLE, "Id"].iloc[0]

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
                    "Data Category": get_variable_names(VARIABLE_ID,matlab_data_variable_names)['Category'][0,0][0],
                    "Sampling Rate (min)": SAMPLING_RATE,
                    "Date": DATE,
                    "Depth": DEPTH,
                    "Variable": VARIABLE,
                    "QC": QC
                }
                
                output_filename = file.replace("DATA","HEADER")

                print(output_filename)
                file_path = os.path.join(dir_header, output_filename)

                header_df = pd.DataFrame({"Header": header_dict.keys(), "Value": header_dict.values()})
                # print(header_df)
                header_df.to_csv(file_path, index=False, header=False)

    var_id_name_df = []
    for dir in dir_lst:
        data_df = process_data(dir)
        var_id_name_df.append(data_df) 
    
    for i in range(len(dir_header)):
        process_header(dir_header[i],var_id_name_df[i],dir_header_raw[i])