def import_dep_smcws(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates):
    import pandas as pd
    import numpy as np
    import os
    import sys
    sys.path.append(str(CODE_DIR))
    from import_py.utils.matlab_utils import get_datapath_from_matlab, get_conversion_data, get_variable_names, get_site_coordinates

    # specify constants
    AGENCY_NAME = "Department of Environmental Protection"
    AGENCY_CODE = "DEP"
    PROGRAM = "Cockburn Sound Monitoring Program"
    PROJECT = "Southern Metropolitan Coastal Waters Study (SMCWS)" 
    STATION_STATUS = "Completed"
    TIME_ZONE = "GMT +8"
    VERT_DATUM = "mAHD"
    DEPLOYMENT = "Profile"
    DEPLOYMENT_POSITION = "m above Seabed"
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
        datapath + "/data-lake/DEP/SMCWS"
    ]
    dir_header = [
        datapath + "/data-warehouse/csv/dep/smcws"
    ]
    dir_header_raw = [
        datapath_raw + "/data-warehouse/csv/dep/smcws"
    ]

    dataset = "DEP"
    dep_data = get_conversion_data(dataset,matlab_data_conversion_data)
    site_dataset = "DEP"
    site_coordinates_data = get_site_coordinates(site_dataset,matlab_data_site_coordinates)
    site_info_df = pd.read_csv(datapath + "/data-lake/DEP/SMCWS/DEP_SMCWS.csv")
    df_lst = []

    def process_data(dir):
        # Initialize the DataFrame to store all variable information
        all_var_info = pd.DataFrame(columns=['Id', 'Name'])

        # Define constants
        EXCLUDED_SHEETS = {'Table Content', 'Table 1', 'Metadata'}
        
        for file in os.listdir(dir):
            if not (file.endswith('.xlsx') and not file.startswith('~$')) and not file.startswith("._"):
                continue
                
            excel_file = pd.ExcelFile(os.path.join(dir, file))
            print(f"Processing file: {file}")
            
            # Filter sheets
            sheet_names = [sheet for sheet in excel_file.sheet_names if sheet not in EXCLUDED_SHEETS]
            
            # Process each sheet
            for sheet_name in sheet_names:
                print(f"Processing sheet: {sheet_name}")
                if file == "SMCWS_Jan1991_Feb1992.xlsx":
                    df = pd.read_excel(
                        excel_file,
                        skiprows=2,
                        sheet_name=sheet_name
                    )
                    # Skip rows containing 'mean' or 'se'
                    df = df[~df.apply(lambda x: x.astype(str).str.contains('mean|se|CS5|CS7|CS8', case=False)).any(axis=1)]
                elif file == "SMCWS_Dec1993_Mar1994.xlsx":
                    df = pd.read_excel(
                        excel_file, 
                        skiprows=1,
                        sheet_name=sheet_name
                    ).iloc[1:]

                # Drop columns where all values are NaN and rows where all values are NaN
                df = df.dropna(axis=1, how='all').dropna(axis=0, how='all')
                df['DATE'] = pd.to_datetime(df['DATE']).dt.strftime('%Y-%m-%d %H:%M:%S')
                df_lst.append(df)

        # Combine all sheets
        df = pd.concat(df_lst, ignore_index=True)
        # print(df)
        
        # Get unique values once
        sample_lst = [s for s in df['SAMPLE'].unique() if 'WS B' not in s]
        # print(sample_lst)
        variables = [col for col in df.columns if col not in {"SAMPLE", "DATE", "PO4"}]

        # Dictionary to store DataFrames by sitecode, measurement_code and name_conv
        output_dfs = {}

        for sample in sample_lst:
            print(sample)
            parts = sample.split(" ")
            sitecode = parts[0]
            measurement_code = parts[1] if len(parts) > 1 else "T"
            print(sitecode, measurement_code)
            
            # Filter once for each sample
            df_sample = df[df['SAMPLE'] == sample]
            sample_dates = df_sample['DATE']

            if "M" in measurement_code:
                DEPTH = site_info_df.loc[site_info_df['SiteCode'] == sitecode, 'Depth'].iloc[0]/2
            elif "T" in measurement_code:
                DEPTH = site_info_df.loc[site_info_df['SiteCode'] == sitecode, 'Depth'].iloc[0]
            else:
                DEPTH = 0
            
            for variable in variables:
                # Create filtered DataFrame
                df_filtered = pd.DataFrame({
                    'Date': sample_dates,
                    'Data': df_sample[variable],
                    'Depth': DEPTH,
                    'QC': 'N'
                })
                
                df_filtered.replace("", np.nan, inplace=True)
                
                # Find matching variable in MATLAB data and get conversion factor
                conv_factor = 1  # default value
                for field in dep_data.dtype.names:
                    # print(f"Field: {field}")
                    # Skip if the field's 'Old' value is empty
                    if dep_data[field][0, 0]['Old'][0,0].size == 0:
                        continue
                    old_name = dep_data[field][0, 0]['Old'][0, 0][0]
                    if old_name == variable:
                        conv_factor = float(dep_data[field][0, 0]['Conv'][0, 0][0])
                        Id = dep_data[field][0, 0]['ID'][0, 0][0]
                        break

                # Convert value of different units
                if conv_factor != 1:
                    df_filtered['Data'] = pd.to_numeric(df_filtered['Data'], errors='coerce')  # Convert non-numeric values to NaN
                    df_filtered['Data'] *= conv_factor
                
                df_filtered = df_filtered.dropna(subset=['Data'])
                
                # Reorder columns
                df_filtered = df_filtered[["Date", "Depth", "Data", "QC"]]

                name_conv = get_variable_names(Id,matlab_data_variable_names)['Name'][0, 0][0]
                # Append to the all_var_info DataFrame
                var_info = pd.DataFrame({
                    'Id': [Id],
                    'Name': [name_conv]
                })
                all_var_info = pd.concat([all_var_info, var_info], ignore_index=True)
                
                if not df_filtered.empty:
                    output_key = f'{sitecode}_{measurement_code}_{name_conv.replace(" ","_")}'
                    
                    if output_key in output_dfs:
                        output_dfs[output_key] = pd.concat([output_dfs[output_key], df_filtered])
                    else:
                        output_dfs[output_key] = df_filtered

        # Process and save each combined DataFrame
        for output_key, combined_df in output_dfs.items():
            # Remove duplicates (ignoring Variable column) and sort by date
            combined_df = combined_df.drop_duplicates(subset=['Date', 'Depth', 'Data', 'QC']).sort_values('Date')

            # Replace "<1" values with 0
            combined_df.loc[combined_df['Data'] == '<1', 'Data'] = 0

            # Group by date and keep first value of Variable along with mean of Data for duplicate dates
            combined_df = combined_df.groupby(['Date', 'Depth', 'QC'], as_index=False).agg({
                'Data': 'mean'
            })

            # Reorder columns
            combined_df = combined_df[["Date", "Depth", "Data", "QC"]]
            
            output_filename = f'py_{output_key}_DATA.csv'
            print(output_filename)
            output_dir = dir.replace("data-lake","data-warehouse/csv") #.lower()

            SPLIT = output_dir.split("data-warehouse/csv")
            output_dir = "data-warehouse/csv".join([SPLIT[0],SPLIT[1].lower()])
            
            print(output_dir)
            os.makedirs(output_dir, exist_ok=True)
            output_path = os.path.join(output_dir, output_filename)
            combined_df.to_csv(output_path, index=False)
            print(combined_df)

        return all_var_info  # Return the DataFrame containing variable IDs and names
    
    def process_derived_variables(dir_header):
        # Dictionary to store data for each sitecode and measurement_code
        data_dict = {}

        for file in os.listdir(dir_header):
            if file.endswith("DATA.csv") and any(param in file for param in ["Total_Dissolved_Nitrogen", "Nitrate_Nitrogen", "Ammonium", "Total_Dissolved_Phosphorus", "Filterable_Reactive_Phosphate"]) and not file.startswith("._"):
                df = pd.read_csv(os.path.join(dir_header, file))
                sitecode = file.split("_")[1]
                measurement_code = file.split("_")[2]
                variable = "_".join(file.split("_")[3:-1])
                
                # Initialize nested dictionary if not exists
                if (sitecode, measurement_code) not in data_dict:
                    data_dict[(sitecode, measurement_code)] = {}
                    
                # Store dataframe in dictionary
                data_dict[(sitecode, measurement_code)][variable] = df

        # print(data_dict)

        # Function to fill missing values using historical median for same month-day
        def fill_with_historical_median(series, dates, month_days):
            filled_series = series.copy()
            for idx in filled_series[filled_series.isna()].index:
                current_md = month_days[idx]
                current_date = dates[idx]
                
                # Try exact month-day first
                historical_vals = series[month_days == current_md]
                
                if len(historical_vals.dropna()) > 0:
                    filled_series[idx] = historical_vals.median()
                else:
                    # If no exact month-day match, find closest dates within ±31 days
                    current_doy = current_date.dayofyear
                    date_diffs = abs(dates.dt.dayofyear - current_doy)
                    nearby_vals = series[date_diffs <= 31]
                    if len(nearby_vals.dropna()) > 0:
                        filled_series[idx] = nearby_vals.median()
            
            return filled_series

        # Calculate derived variables for each sitecode and measurement_code
        for (sitecode, measurement_code), variables in data_dict.items():
            print(sitecode, measurement_code)
            if all(var in variables for var in ["Total_Dissolved_Nitrogen", "Nitrate_Nitrogen", "Ammonium"]):
                # Create dataframes directly with final column names
                tdn = variables["Total_Dissolved_Nitrogen"][["Date", "Data"]].rename(columns={"Data": "TDN_Data"})
                no3 = variables["Nitrate_Nitrogen"][["Date", "Data"]].rename(columns={"Data": "NO3_Data"})
                nh4 = variables["Ammonium"][["Date", "Data"]].rename(columns={"Data": "NH4_Data"})
                
                # Merge and sort in one chain
                don_df = (tdn.merge(no3, on='Date', how='outer')
                            .merge(nh4, on='Date', how='outer')
                            .sort_values('Date'))
                
                # Convert Date to datetime for proper processing
                don_df['Date'] = pd.to_datetime(don_df['Date'])
                
                # Add month-day column for grouping
                don_df['month_day'] = don_df['Date'].dt.strftime('%m-%d')
                
                # Apply historical median filling for each variable
                for col in ['TDN_Data', 'NO3_Data', 'NH4_Data']:
                    don_df[col] = fill_with_historical_median(
                        don_df[col], 
                        don_df['Date'],
                        don_df['month_day']
                    )
                    # Use linear interpolation for any remaining NaN values
                    don_df[col] = don_df[col].interpolate(method='linear')
                    don_df[col] = don_df[col].ffill().bfill()
                    
                # Calculate DON
                don_df['DON'] = don_df['TDN_Data'] - don_df['NO3_Data'] - don_df['NH4_Data']

                don_df_export = don_df[["Date", "DON"]]
                don_df_export.columns = ["Date", "Data"]
                don_df_export['Date'] = pd.to_datetime(don_df_export['Date']).dt.strftime('%Y-%m-%d %H:%M:%S')
                don_df_export['Depth'] = variables["Total_Dissolved_Nitrogen"]["Depth"].iloc[0]
                don_df_export['QC'] = 'N'
                don_df_export['Variable'] = 'Derived DON'
                don_df_export = don_df_export[["Date", "Depth", "Data", "QC"]]
                print(don_df_export)
                
                don_df_export.to_csv(os.path.join(dir_header, f"py_{sitecode}_{measurement_code}_Dissolved_Organic_Nitrogen_DATA.csv"), index=False)
                
            if all(var in variables for var in ["Total_Dissolved_Phosphorus", "Filterable_Reactive_Phosphate"]):
                # Create dataframes directly with final column names
                tdp = variables["Total_Dissolved_Phosphorus"][["Date", "Data"]].rename(columns={"Data": "TDP_Data"})
                frp = variables["Filterable_Reactive_Phosphate"][["Date", "Data"]].rename(columns={"Data": "FRP_Data"})
                
                # Merge and sort in one chain
                dop_df = (tdp.merge(frp, on='Date', how='outer')
                            .sort_values('Date'))
                
                # Convert Date to datetime for proper processing
                dop_df['Date'] = pd.to_datetime(dop_df['Date'])
                
                # Add month-day column for grouping
                dop_df['month_day'] = dop_df['Date'].dt.strftime('%m-%d')
                
                # Apply historical median filling for each variable
                for col in ['TDP_Data', 'FRP_Data']:
                    dop_df[col] = fill_with_historical_median(
                        dop_df[col], 
                        dop_df['Date'],
                        dop_df['month_day']
                    )
                    dop_df[col] = dop_df[col].interpolate(method='linear')
                    dop_df[col] = dop_df[col].ffill().bfill()
                
                # Calculate DOP
                dop_df['DOP'] = dop_df['TDP_Data'] - dop_df['FRP_Data']

                dop_df_export = dop_df[["Date", "DOP"]]
                dop_df_export.columns = ["Date", "Data"]
                dop_df_export['Date'] = pd.to_datetime(dop_df_export['Date']).dt.strftime('%Y-%m-%d %H:%M:%S')
                dop_df_export['Depth'] = variables["Total_Dissolved_Phosphorus"]["Depth"].iloc[0]
                dop_df_export['QC'] = 'N'
                dop_df_export['Variable'] = 'Derived DOP'
                dop_df_export = dop_df_export[["Date", "Depth", "Data", "QC"]]
                print(dop_df_export)
                
                dop_df_export.to_csv(os.path.join(dir_header, f"py_{sitecode}_{measurement_code}_Dissolved_Organic_Phosphorus_DATA.csv"), index=False)
    
    def process_header(dir_header,var_id_name_df,dir_header_raw):
        for file in os.listdir(dir_header):
            if file.endswith('_DATA.csv') and file.startswith("py") and not file.startswith("._"):
                print(f"Datafile: {file}")
                NATIONAL_STATION_ID = file.split("_")[1]
                if "CS" in NATIONAL_STATION_ID:
                    SITE_DESCRIPTION = f'Cockburn Sound Site {NATIONAL_STATION_ID[2]} {file.split("_")[2]}'
                elif "WS" in NATIONAL_STATION_ID:
                    SITE_DESCRIPTION = f'Warnbro Sound Site {NATIONAL_STATION_ID[2]} {file.split("_")[2]}'
                elif "SD" in NATIONAL_STATION_ID:
                    SITE_DESCRIPTION = f'Sepia Depression Site {NATIONAL_STATION_ID[2]} {file.split("_")[2]}'
                elif "MS" in NATIONAL_STATION_ID:
                    SITE_DESCRIPTION = f"Mid-Shelf (up to about 10km offshore of Cape Peron and Warnbro Sound) Site {NATIONAL_STATION_ID[2]} {file.split('_')[2]}"
                SITE_DESCRIPTION = SITE_DESCRIPTION.replace(" B"," (bottom)").replace(" M"," (mid-depth)").replace(" T"," (surface)")
                print(file)
                print(NATIONAL_STATION_ID)

                site_coordinates = site_coordinates_data[NATIONAL_STATION_ID][0,0]
                LAT = round(site_coordinates["Lat"][0,0][0][0], 4)
                LONG = round(site_coordinates["Lon"][0,0][0][0], 4)
            
                TAG = AGENCY_CODE + "-" + PROJECT.split("(")[1].strip(")") + "-" + NATIONAL_STATION_ID[:2]

                VARIABLE = " ".join(file.split("_")[3:-1])
                # print(VARIABLE)
                # print(var_id_name_df)
                VARIABLE_ID = var_id_name_df.loc[var_id_name_df["Name"] == VARIABLE, "Id"].iloc[0]
                # print(VARIABLE_ID)

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
        process_derived_variables(dir_header[i])
    
    derived_var_info = pd.DataFrame({
        'Id': ['var00032','var00035'],
        'Name': ['Dissolved Organic Nitrogen','Dissolved Organic Phosphorus']
    })
    for i in range(len(var_id_name_df)):
        var_id_name_df[i] = pd.concat([var_id_name_df[i], derived_var_info], ignore_index=True)

    for i in range(len(dir_header)):
        process_header(dir_header[i],var_id_name_df[i],dir_header_raw[i])