def import_uwa_wawaves(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates):
    import pandas as pd
    import numpy as np
    import os
    import sys
    from zoneinfo import ZoneInfo
    sys.path.append(str(CODE_DIR))
    from import_py.utils.matlab_utils import get_datapath_from_matlab, get_conversion_data, get_variable_names, get_site_coordinates

    # specify constants
    AGENCY_NAME = "The University of Western Australia"
    AGENCY_CODE = "UWA"
    PROGRAM = "Oceans Institute WA Waves"
    PROJECT = "Wave buoy data"
    TAG = "UWA-WAWAVES"
    STATION_STATUS = "Historic"
    LAT = -31.8465995
    LON = 115.642707
    TIME_ZONE = "GMT +8"
    VERT_DATUM = "mAHD"
    SITE_DESCRIPTION = "Hillarys buoy"
    DEPLOYMENT = "Floating"
    DEPLOYMENT_POSITION = "m from surface"
    VERT_REF = "Water Surface"
    SITE_MEAN_DEPTH = ""
    BAD_VALUE = 'NaN'
    EMAIL = "Yvette <00114814@uwa.edu.au>"
    SAMPLING_RATE = "60 min"
    DATE = "yyyy-mm-dd HH:MM:SS"
    DEPTH = "Decimal"
    QC = "NaN"

    datapath,datapath_raw = get_datapath_from_matlab(ACTIONS_DIR,base_path)
    print(f"Current datapath: {datapath}")

    dir_lst = [
        datapath + "/data-lake/UWA/WAWAVES"
    ]
    dir_header = [
        datapath + "/data-warehouse/csv/uwa/wawaves"
    ]
    dir_header_raw = [
        datapath_raw + "/data-warehouse/csv/uwa/wawaves"
    ]

    dataset = "UWA"
    uwa_data = get_conversion_data(dataset,matlab_data_conversion_data)
    site_dataset = "UWA"
    site_coordinates_data = get_site_coordinates(site_dataset,matlab_data_site_coordinates)

    def convert_timestamp_to_perth_time(timestamp):
        # Convert Unix timestamp to datetime object
        utc_time = pd.to_datetime(timestamp, unit='s', utc=True)
        
        # Convert to Perth time
        perth_tz = ZoneInfo("Australia/Perth")
        perth_time = utc_time.dt.tz_convert(perth_tz)
        
        # Format the Perth time
        formatted_perth = perth_time.dt.strftime("%d/%m/%Y %H:%M")
        
        return formatted_perth

    def process_data(dir):
        # Initialize the DataFrame to store all variable information
        all_var_info = pd.DataFrame(columns=['Id', 'Name'])

        for file in os.listdir(dir):
            if file.endswith(".csv") and "buoy-67-" in file and not file.startswith("._"):
                print(file)
                df = pd.read_csv(os.path.join(dir, file), header=0)
                df['Date'] = convert_timestamp_to_perth_time(df['Time (UNIX/UTC)'])
                
                df['Date'] = pd.to_datetime(df['Date'], format='%d/%m/%Y %H:%M', dayfirst=True)
                df['Date'] = df['Date'].dt.strftime('%Y-%m-%d %H:%M:%S')
                # Drop columns if all rows are -9999
                df = df.loc[:, (df != -9999).any()]
                # Drop the specified columns
                df = df.drop(columns=['Time (UNIX/UTC)', 'Timestamp (UTC)'], errors='ignore')
                
                # Move 'Date' column to the first position
                cols = df.columns.tolist()
                cols.insert(0, cols.pop(cols.index('Date')))
                df = df[cols]
                # print(df)

                var_lst = df.columns.to_list()
                variables = [var for var in var_lst if var.strip() not in ['Date','Site','BuoyID','Latitude (deg)','Longitude (deg)','buoy_id','QF_waves','QF_sst','QF_bott_temp']]

                for variable in variables:
                    df_filtered = pd.DataFrame()  # Initialize an empty DataFrame

                    df_filtered['Date'] = df['Date']
                    df_filtered['Data'] = df[variable]
                    df_filtered['Variable'] = variable
                    df_filtered['Depth'] = 0
                    df_filtered['QC'] = 'N'

                    df_filtered = df_filtered.sort_values(by='Date')

                    # Replace empty cells with NaN
                    df_filtered.replace("", np.nan, inplace=True)

                    # Convert value of different units
                    print(variable)
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

                    # Add debug print for variable
                    # print(f"Processing variable: {variable}")
                    # Convert value of different units
                    if conv_factor != 1:
                        df_filtered['Data'] = pd.to_numeric(df_filtered['Data'], errors='coerce')  # Convert non-numeric values to NaN
                        df_filtered['Data'] *= conv_factor

                    # Drop rows where Data is NaN
                    df_filtered = df_filtered.dropna(subset=['Data'])

                    df_filtered = df_filtered.loc[:, ["Date", "Depth", "Data", "QC"]]

                    print(df_filtered)

                    name_conv = get_variable_names(Id,matlab_data_variable_names)['Name'][0, 0][0]
                    # Append to the all_var_info DataFrame
                    var_info = pd.DataFrame({
                        'Id': [Id],
                        'Name': [name_conv]
                    })
                    all_var_info = pd.concat([all_var_info, var_info], ignore_index=True)

                    output_dir = dir.replace("data-lake","data-warehouse/csv")
                    
                    SPLIT = output_dir.split("data-warehouse/csv")
                    output_dir = "data-warehouse/csv".join([SPLIT[0],SPLIT[1].lower()])

                    os.makedirs(output_dir, exist_ok=True)
                    output_filename = f'py_{"".join(file.split("-")[0:2])}_{name_conv.replace(" ","_")}_DATA.csv'.replace("/","")
                    print(output_dir)
                    print(output_filename)

                    if not df_filtered.empty:
                        df_filtered.to_csv(os.path.join(output_dir, output_filename), index=False)

        return all_var_info  # Return the DataFrame containing variable IDs and names
    
    def process_header(dir_header,var_id_name_df,dir_header_raw):
        for file in os.listdir(dir_header):
            if file.endswith('_DATA.csv') and file.startswith("py") and not file.startswith("._"):
                print(f"Datafile: {file}")

                NATIONAL_STATION_ID = f'uwa_hillarys_{file.split("_")[1]}'

                VARIABLE = " ".join(file.split("_")[2:-1])
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
                    "Long": LON,
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
                header_df.to_csv(file_path, index=False,header=False)
    
    var_id_name_df = []
    for dir in dir_lst:
        data_df = process_data(dir)
        var_id_name_df.append(data_df)

    for i in range(len(dir_header)):
        process_header(dir_header[i],var_id_name_df[i],dir_header_raw[i])