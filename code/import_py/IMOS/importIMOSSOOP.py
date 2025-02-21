def import_imos_soop(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates):
    import pandas as pd
    import numpy as np
    import os
    import sys
    sys.path.append(str(CODE_DIR))
    from import_py.utils.matlab_utils import get_datapath_from_matlab, get_conversion_data, get_variable_names, get_site_coordinates

    # specify constants
    AGENCY_NAME = "Integrated Marine Observing System"
    AGENCY_CODE = "IMOS"
    PROGRAM = "Ships of Opportunity (SOOP)"
    PROJECT = "Perth waters gridded SOOP data"
    STATION_STATUS = "Active"
    TIME_ZONE = "GMT +8"
    VERT_DATUM = "mAHD"
    DEPLOYMENT = "Floating"
    DEPLOYMENT_POSITION = "0m below Surface"
    VERT_REF = "m below Surface"
    SITE_MEAN_DEPTH = ""
    BAD_VALUE = 'NaN'
    EMAIL = "Yvette <00114814@uwa.edu.au>"
    SAMPLING_RATE = ""
    DATE = "yyyy-mm-dd HH:MM:SS"
    DEPTH = "Decimal"
    QC = "Z (value passes all tests)"

    datapath,datapath_raw = get_datapath_from_matlab(ACTIONS_DIR,base_path)
    print(f"Current datapath: {datapath}")
    dir_lst = [
        datapath + "/data-lake/IMOS/SOOP/PERTH/ALL"
    ]
    dir_header = [ 
        datapath + "/data-warehouse/csv/imos/soop/perth"
    ]
    dir_header_raw = [
        datapath_raw + "/data-warehouse/csv/imos/soop/perth"
    ]

    dataset = "IMOS"
    imos_data = get_conversion_data(dataset,matlab_data_conversion_data)
    # print(f"IMOS data structure: {imos_data}")
    # print(f"IMOS data fields: {imos_data.dtype.names}")
    site_dataset = "IMOSSOOP"
    site_coordinates_data = get_site_coordinates(site_dataset,matlab_data_site_coordinates)

    def process_data(dir):
        # Initialize the DataFrame to store all variable information
        all_var_info = pd.DataFrame(columns=['Id', 'Name'])

        for file in os.listdir(dir):
            if file.endswith("hourly.xlsx") and not file.startswith("._"):
                print(file)
                # Read all sheets in the spreadsheet
                excel_file = pd.ExcelFile(os.path.join(dir, file))
                for sheet_name in excel_file.sheet_names:
                    df = pd.read_excel(excel_file, sheet_name=sheet_name)
                    grid_id = sheet_name
                    # Process the data for each sheet
                    print(f"Processing sheet: {grid_id}")
                    df['Date'] = pd.to_datetime(df['TIME'])
                    df['Date'] = df['Date'].dt.strftime('%Y-%m-%d %H:%M:%S')
                    df = df.drop('TIME', axis=1)  # Remove the TIME column
                    # Move Date column to first position
                    cols = df.columns.tolist()
                    cols = ['Date'] + [col for col in cols if col != 'Date']
                    df = df[cols]
                    print(f"df:\n{df}")
                    
                    variable = file.split("_")[2]

                    df_filtered = df[['Date', 'Avg']].rename(columns={'Avg': 'Data'})
                    df_filtered['Variable'] = variable
                    df_filtered['Depth'] = 0
                    df_filtered['QC'] = 'Z'
                    df_filtered = df_filtered.sort_values(by='Date')

                    # Replace empty cells with NaN
                    df_filtered.replace("", np.nan, inplace=True)

                    df_filtered = df_filtered.loc[:, ["Date", "Depth", "Data", "QC"]]

                    # Find matching variable in MATLAB data and get conversion factor
                    conv_factor = 1  # default value
                    for field in imos_data.dtype.names:
                        # print(f"Field: {field}")
                        # Skip if the field's 'Old' value is empty
                        if imos_data[field][0, 0]['Old'][0,0].size == 0:
                            continue
                        old_name = imos_data[field][0, 0]['Old'][0, 0][0]
                        if old_name == variable:
                            conv_factor = float(imos_data[field][0, 0]['Conv'][0, 0][0])
                            Id = imos_data[field][0, 0]['ID'][0, 0][0]
                            break

                    # Add debug print for variable
                    # print(f"Processing variable: {variable}")
                    # Convert value of different units
                    if conv_factor != 1:
                        df_filtered['Data'] = pd.to_numeric(df_filtered['Data'], errors='coerce')  # Convert non-numeric values to NaN
                        df_filtered['Data'] *= conv_factor
                    
                    print(f"df_filtered:\n{df_filtered}")

                    name_conv = get_variable_names(Id,matlab_data_variable_names)['Name'][0, 0][0]
                    # Append to the all_var_info DataFrame
                    var_info = pd.DataFrame({
                        'Id': [Id],
                        'Name': [name_conv]
                    })
                    all_var_info = pd.concat([all_var_info, var_info], ignore_index=True)
                    output_filename = f'py_{grid_id.split("_")[0]}{file.split("_")[3]}_{grid_id.split("_")[1]}_{name_conv.replace(" ","_")}_DATA.csv'

                    print(output_filename)

                    # Write the filtered DataFrame to a CSV file in the specified directory only if it's not empty
                    output_dir = dir.replace("data-lake","data-warehouse/csv")
                    output_dir = "/".join(output_dir.split("/")[:-1]) #.lower()

                    SPLIT = output_dir.split("data-warehouse/csv")
                    output_dir = "data-warehouse/csv".join([SPLIT[0],SPLIT[1].lower()])
                    
                    os.makedirs(output_dir, exist_ok=True)
                    
                    if not df_filtered.empty:
                        df_filtered.to_csv(os.path.join(output_dir, output_filename), index=False)
        
        return all_var_info  # Return the DataFrame containing variable IDs and names
    
    def process_header(dir_header,var_id_name_df,dir_header_raw):
        for file in os.listdir(dir_header):
            if file.endswith('_DATA.csv') and file.startswith("py") and not file.startswith("._"):
                print(f"Datafile: {file}")

                NATIONAL_STATION_ID = "_".join(file.split("_")[1:3])
                SITE_DESCRIPTION = NATIONAL_STATION_ID

                site_coordinates = site_coordinates_data[NATIONAL_STATION_ID][0,0]
                LAT = round(site_coordinates["Lat"][0,0][0][0], 4)
                LONG = round(site_coordinates["Lon"][0,0][0][0], 4)
                        
                TAG = AGENCY_CODE + "-" + PROGRAM.split("(")[1].strip(")") + "-PERTH"

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
                header_df.to_csv(file_path, index=False,header=False)

    var_id_name_df = []
    for dir in dir_lst:
        data_df = process_data(dir)
        var_id_name_df.append(data_df)

    for i in range(len(dir_header)):
        process_header(dir_header[i],var_id_name_df[i],dir_header_raw[i])