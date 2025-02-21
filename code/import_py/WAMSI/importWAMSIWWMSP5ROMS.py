def import_wamsi_wwmsp5_roms(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates):
    import pandas as pd
    import numpy as np
    import os
    import sys
    sys.path.append(str(CODE_DIR))
    from import_py.utils.matlab_utils import get_datapath_from_matlab, get_conversion_data, get_variable_names, get_site_coordinates

    # specify constants
    AGENCY_NAME = "Western Australian Marine Science Institution"
    AGENCY_CODE = "WAMSI"
    PROGRAM = "WWMSP5"  #"Westport Marine Science Program (WWMSP5)"
    PROJECT = "Regional Ocean Modelling Systems (ROMS)" 
    STATION_STATUS = "Active"
    TIME_ZONE = "GMT +8"
    VERT_DATUM = "mAHD"
    DEPLOYMENT = "Profile"
    DEPLOYMENT_POSITION = "0m below Surface"
    VERT_REF = "m below Surface"
    SITE_MEAN_DEPTH = ""
    BAD_VALUE = 'NaN'
    EMAIL = "Yvette <00114814@uwa.edu.au>"
    SAMPLING_RATE = "/day"
    DATE = "yyyy-mm-dd HH:MM:SS"
    DEPTH = "Decimal"
    QC = "NaN"

    datapath,datapath_raw = get_datapath_from_matlab(ACTIONS_DIR,base_path)
    print(f"Current datapath: {datapath}")

    dir_lst = [
        datapath + "/data-lake/WAMSI/WWMSP5/ROMS/Perth_ROMS_0.5km_2023",
        datapath + "/data-lake/WAMSI/WWMSP5/ROMS/WA_ROMS_2km_2000-2022"
    ]

    dir_header = [
        datapath + "/data-warehouse/csv/wamsi/wwmsp5/roms/perth_roms_0.5km_2023",
        datapath + "/data-warehouse/csv/wamsi/wwmsp5/roms/wa_roms_2km_2000-2022"
    ]

    dir_header_raw = [
        datapath_raw + "/data-warehouse/csv/wamsi/wwmsp5/roms/perth_roms_0.5km_2023",
        datapath_raw + "/data-warehouse/csv/wamsi/wwmsp5/roms/wa_roms_2km_2000-2022"
    ]

    dataset = "wwmsp5"
    wamsi_data = get_conversion_data(dataset,matlab_data_conversion_data)
    site_dataset = "WWMSP5ROMS"
    site_coordinates_data = get_site_coordinates(site_dataset,matlab_data_site_coordinates)

    def process_data(dir):
        # Initialize the DataFrame to store all variable information
        all_var_info = pd.DataFrame(columns=['Id', 'Name'])

        for file in os.listdir(dir):
            if file.endswith(".csv") and not file.startswith("._"):
                print(file)
                df = pd.read_csv(os.path.join(dir, file), header=0)
                df['Date'] = pd.to_datetime(df['ocean_time'], format='%Y-%m-%d %H:%M:%S')

                for variable in ['temp','salt']:
                    df_filtered = df[['Date', variable,'s_rho']]
                    df_filtered = df_filtered.rename(columns={variable: 'Data', 's_rho': 'Depth'})
                    df_filtered['Variable'] = variable
                    df_filtered['QC'] = 'N'

                    df_filtered.replace("", np.nan, inplace=True)

                    # Find matching variable in MATLAB data and get conversion factor
                    conv_factor = 1  # default value
                    for field in wamsi_data.dtype.names:
                        # print(f"Field: {field}")
                        # Skip if the field's 'Old' value is empty
                        if wamsi_data[field][0, 0]['Old'][0,0].size == 0:
                            continue
                        old_name = wamsi_data[field][0, 0]['Old'][0, 0][0]
                        if old_name == variable:
                            conv_factor = float(wamsi_data[field][0, 0]['Conv'][0, 0][0])
                            Id = wamsi_data[field][0, 0]['ID'][0, 0][0]
                            break

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
                    
                    df_filtered = df_filtered.loc[:, ["Date", "Depth", "Data", "QC"]]

                    if "Perth_ROMS_0.5km_2023" in dir:
                        output_filename = f'py_{file.split("_",4)[-1].replace(".csv","").replace("_","")}_500m_{name_conv.replace(" ","")}_DATA.csv'.replace("moooring","mooring")
                    elif "WA_ROMS_2km_2000-2022" in dir:
                        output_filename = f'py_{file.split("_",5)[-1].replace(".csv","").replace("_","")}_2km_{name_conv.replace(" ","")}_DATA.csv'.replace("moooring","mooring")

                    # Write the filtered DataFrame to a CSV file in the specified directory only if it's not empty
                    output_dir = dir.replace("data-lake","data-warehouse/csv")
                    if "perth" in output_dir:
                        output_dir = output_dir.replace("perth_roms_0.5km_2023","perth")
                    elif "wa" in output_dir:
                        output_dir = output_dir.replace("wa_roms_2km_2000-2022","wa")

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
                if "polygon" in NATIONAL_STATION_ID:
                    NATIONAL_STATION_ID = NATIONAL_STATION_ID.split("_")[0].replace("polygon","polygon_")
                else:
                    NATIONAL_STATION_ID = NATIONAL_STATION_ID.replace("mooring","mooring_")

                site_coordinates = site_coordinates_data[NATIONAL_STATION_ID][0,0]
                
                SITE_DESCRIPTION = site_coordinates["Description"][0,0][0]

                LAT = site_coordinates["Lat"][0,0][0][0]
                LONG = site_coordinates["Lon"][0,0][0][0]

                TAG = AGENCY_CODE + "-" + PROGRAM + "-" + "-".join(dir_header_raw.split("/")[-1].split("_")[0:2]).upper()

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
                header_df.to_csv(file_path, index=False,header=False)
                print(f"Headerfile: {file_path}")
    
    var_id_name_df = []
    for dir in dir_lst:
        data_df = process_data(dir)
        var_id_name_df.append(data_df)

    for i in range(len(dir_header)):
        process_header(dir_header[i],var_id_name_df[i],dir_header_raw[i])