def import_dwer_csmooring_MS9D(CODE_DIR, ACTIONS_DIR, base_path, matlab_data_conversion_data, matlab_data_variable_names, matlab_data_site_coordinates):
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
    DEPLOYMENT = "Fixed"
    DEPLOYMENT_POSITION = "1.0m above Bottom"
    VERT_REF = "m above Bottom"
    SITE_MEAN_DEPTH = "2.5"
    BAD_VALUE = "NaN"
    EMAIL = "Santiago <00114911@uwa.edu.au>"
    DATE = "yyyy-mm-dd HH:MM:SS"
    DEPTH = "Decimal"
    QC = "N"

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

    input_dir = os.path.join(datapath, "data-lake", "DWER", "CSMOORING", "D-CS86_DUALMS9")

    output_dir = os.path.join(datapath, "data-warehouse", "csv", "dwer", "csmooring", "D")
    os.makedirs(output_dir, exist_ok=True)

    output_dir_raw = os.path.join(datapath_raw, "data-warehouse/csv/dwer/csmooring/D/")

    dataset = "dwer"
    run_start = time.time()
    agency_data = get_conversion_data(dataset, matlab_data_conversion_data)
    site_dataset = "dwermooring"
    site_coordinates_data = get_site_coordinates(site_dataset, matlab_data_site_coordinates)

    def matlab_str(value):
        if isinstance(value, str):
            return value
        if isinstance(value, bytes):
            return value.decode("utf-8", errors="ignore")
        if isinstance(value, np.ndarray):
            if value.size == 0:
                return ""
            return matlab_str(value.flat[0])
        return str(value)

    # Find header row in the input CSV
    def find_header_index(file_path, max_lines=300):
        with open(file_path, "r", encoding="utf-8", errors="ignore") as handle:
            for idx, line in enumerate(handle):
                if line.strip().lower().startswith("timestamp"):
                    return idx
                if idx >= max_lines:
                    break
        return None

    def process_data(input_dir):
        known_variables = set()
        for field in agency_data.dtype.names:
            entry = agency_data[field][0, 0]
            old_name = matlab_str(entry["Old"])
            if old_name:
                known_variables.add(old_name)

        var_old = "Kd_PAR"
        if var_old not in known_variables:
            print("Kd_PAR not found in agency.dwer variable key (Old names).")
            return pd.DataFrame(columns=["Id", "Name"])

        conv_factor = 1.0
        var_id = None
        for field in agency_data.dtype.names:
            entry = agency_data[field][0, 0]
            old_name = matlab_str(entry["Old"])
            if old_name == var_old:
                conv_factor = float(entry["Conv"][0, 0][0])
                var_id = entry["ID"][0, 0][0]
                break

        if var_id is None:
            print(f"Variable ID not found for Old name '{var_old}'")
            return pd.DataFrame(columns=["Id", "Name"])

        var_name = str(get_variable_names(var_id, matlab_data_variable_names)["Name"][0, 0][0]).strip()
        filevar = var_name.replace(" ", "_")

        input_file = os.path.join(input_dir, "CS86_Kd_Interpolated_Trustworthy_Hourly.csv")
        if not os.path.exists(input_file):
            print(f"Input file not found: {input_file}")
            return pd.DataFrame(columns=["Id", "Name"])

        site_id = "dwermooringCS86"
        if site_id not in site_coordinates_data.dtype.names:
            print(f"Site {site_id} not found in site key.")
            return pd.DataFrame(columns=["Id", "Name"])

        header_idx = find_header_index(input_file)
        if header_idx is None:
            print(f"Unable to find header row in {input_file}")
            return pd.DataFrame(columns=["Id", "Name"])

        df = pd.read_csv(input_file, skiprows=header_idx)
        if "Kd_PAR" not in df.columns:
            print(f"Kd_PAR column not found in {input_file}")
            return pd.DataFrame(columns=["Id", "Name"])

        df["Timestamp"] = pd.to_datetime(df["Timestamp"], format="%d/%m/%Y %H:%M:%S", errors="coerce")
        df = df.dropna(subset=["Timestamp", "Kd_PAR"])
        if df.empty:
            return pd.DataFrame(columns=["Id", "Name"])

        df["Kd_PAR"] = pd.to_numeric(df["Kd_PAR"], errors="coerce") * conv_factor
        df = df.dropna(subset=["Kd_PAR"])
        if df.empty:
            return pd.DataFrame(columns=["Id", "Name"])

        out = pd.DataFrame({
            "Date": df["Timestamp"].dt.strftime("%Y-%m-%d %H:%M:%S"),
            "Depth": 2.5,
            "Data": df["Kd_PAR"],
            "QC": QC,
        })

        output_filename = f"{site_id}_{filevar}_MS9D_DATA.csv"
        out.to_csv(os.path.join(output_dir, output_filename), index=False)

        return pd.DataFrame({"Id": [var_id], "Name": [var_name]})

    def process_header(dir_header, var_id_name_df, dir_header_raw):
        for file in os.listdir(dir_header):
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
            try:
                ms9d_idx = name_parts.index("MS9D")
            except ValueError:
                print(f"Skipping {file}: MS9D marker not found.")
                continue

            variable_name = " ".join(name_parts[1:ms9d_idx]).replace("_", " ").replace("-", " ").strip()
            deployment_label = DEPLOYMENT

            NATIONAL_STATION_ID = site_id
            if NATIONAL_STATION_ID not in site_coordinates_data.dtype.names:
                print(f"Skipping {file}: site {NATIONAL_STATION_ID} not found in site key.")
                continue

            site_coordinates = site_coordinates_data[NATIONAL_STATION_ID][0, 0]
            SITE_DESCRIPTION = site_coordinates["Description"][0, 0][0]
            LAT = site_coordinates["Lat"][0, 0][0][0]
            LONG = site_coordinates["Lon"][0, 0][0][0]
            TAG = AGENCY_CODE + "-" + "CSMOORING" + "-" + "MS9D"

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
                "Deployment": deployment_label,
                "Deployment Position": DEPLOYMENT_POSITION,
                "Vertical Reference": VERT_REF,
                "Site Mean Depth": SITE_MEAN_DEPTH,
                "Bad or Unavailable Data Value": BAD_VALUE,
                "Contact Email": EMAIL,
                "Variable ID": VARIABLE,
                "Data Category": get_variable_names(VARIABLE, matlab_data_variable_names)["Category"][0, 0][0],
                "Sampling Rate (min)": 60,
                "Date": DATE,
                "Depth": DEPTH,
                "Variable": f"{variable_name} ({get_variable_names(VARIABLE, matlab_data_variable_names)['Unit'][0,0][0]})",
                "QC": "String",
            }

            header_path = os.path.join(dir_header, file.replace("_DATA.csv", "_HEADER.csv"))
            with open(header_path, "w", encoding="utf-8") as f:
                for key, value in header_dict.items():
                    f.write(f"{key},{value}\n")

    var_id_name_df = process_data(input_dir)
    process_header(output_dir, var_id_name_df, output_dir_raw)
    print("MS9D import complete")
