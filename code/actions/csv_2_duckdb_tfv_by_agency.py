import duckdb
import pandas as pd
import os
import re
from datetime import datetime
from pathlib import Path
from scipy.io import loadmat
import glob
import numpy as np

# Define the base directory
current_path = Path(__file__).absolute()
base_path = current_path.parents[3]
ACTIONS_DIR = Path(__file__).parent
ACTIONS_DIR = ACTIONS_DIR.resolve()  
print("ACTIONS_DIR:", ACTIONS_DIR)
CODE_DIR = base_path / "csiem-data" / "code"

# Load auxiliary MATLAB .mat files used in conversions and metadata mapping
print("Load MATLAB data:")
print("Loading agency.mat") 
matlab_data_conversion_data = loadmat(str(ACTIONS_DIR / 'agency.mat'))
print("Loading varkey.mat")
matlab_data_variable_names = loadmat(str(ACTIONS_DIR / 'varkey.mat'))
print("Loading sitekey.mat")
matlab_data_site_coordinates = loadmat(str(ACTIONS_DIR / 'sitekey.mat'))
print("Done")

# Debug: Print the structure of agency.mat for inspection
print('agency.mat keys:', matlab_data_conversion_data.keys())
print('agency struct type:', type(matlab_data_conversion_data['agency']))
print('agency struct contents:', matlab_data_conversion_data['agency'])

# Set the DuckDB database path
dbpath = ACTIONS_DIR / "duckdb" / "csiem.duckdb"

# Ensure the target directory exists
dbpath.parent.mkdir(parents=True, exist_ok=True)

# Connect to (or create if it does not exist) the DuckDB database
con = duckdb.connect(str(dbpath))

# Create the necessary tables in the DuckDB database
con.execute("""
CREATE TABLE IF NOT EXISTS agencies (
    agency_id INTEGER PRIMARY KEY,
    agency_code TEXT NOT NULL,
    agency_name TEXT
);
""")

con.execute("""
CREATE TABLE IF NOT EXISTS variables (
    variable_id INTEGER PRIMARY KEY,
    variable_code TEXT NOT NULL,       -- e.g., 'WQ_1'
    tfv_name TEXT,                     -- name used in TFV model
    tfv_units TEXT,                    -- e.g., 'mg/L'
    tfv_conv DOUBLE                    -- conversion factor
);
""")

con.execute("""
CREATE TABLE IF NOT EXISTS sites (
    site_id INTEGER PRIMARY KEY,
    site_code TEXT NOT NULL,          -- e.g., 'DWER_1234_Fixed_1'
    agency_id INTEGER,
    station_id TEXT,
    deployment TEXT,
    lat DOUBLE,
    lon DOUBLE,
    xutm DOUBLE,
    yutm DOUBLE,
    calc_smd DOUBLE,
    mah_d DOUBLE,
    FOREIGN KEY (agency_id) REFERENCES agencies(agency_id)
);
""")

con.execute("""
CREATE TABLE IF NOT EXISTS measurements (
    measurement_id BIGINT PRIMARY KEY,
    site_id INTEGER NOT NULL,
    variable_id INTEGER NOT NULL,
    date TIMESTAMP NOT NULL,
    value DOUBLE,                     -- processed data
    raw_value DOUBLE,                 -- original unconverted value
    depth DOUBLE,
    qc_code TEXT,
    FOREIGN KEY (site_id) REFERENCES sites(site_id),
    FOREIGN KEY (variable_id) REFERENCES variables(variable_id)
);
""")

# Function to insert agency data
def load_agencies(matlab_agency_data):
    """
    Extract agency codes and names from individual agency structs in the .mat file and insert into the database.
    """
    for key in matlab_agency_data:
        if key.startswith('__'):
            continue  

        agency_struct = matlab_agency_data[key]
        if agency_struct.dtype.names is None:
            continue  

        try:
            agency_code = str(agency_struct['Agency_Code'][0, 0][0])
            agency_name = str(agency_struct['Agency_Name'][0, 0][0])
        except Exception as e:
            print(f"Skipping {key} due to error: {e}")
            continue

        try:
            con.execute("""
                INSERT INTO agencies (agency_code, agency_name)
                VALUES (?, ?)
            """, (agency_code, agency_name))
        except duckdb.ConstraintException:
            pass  

    print("Agencies loaded successfully.")

def load_variables(matlab_variable_data):
    """
    Extract variable metadata from varkey.mat and insert into the database.
    """
    varkey_struct = matlab_variable_data['varkey']
    for key in varkey_struct.dtype.names:
        try:
            entry = varkey_struct[key][0, 0]
            tfv_name = str(entry['tfvName'][0]) if entry['tfvName'].size > 0 else None
            tfv_units = str(entry['tfvUnits'][0]) if entry['tfvUnits'].size > 0 else None
            tfv_conv = float(entry['tfvConv'][0, 0]) if entry['tfvConv'].size > 0 else 1.0

            con.execute("""
                INSERT INTO variables (variable_code, tfv_name, tfv_units, tfv_conv)
                VALUES (?, ?, ?, ?)
            """, (key, tfv_name, tfv_units, tfv_conv))
        except duckdb.ConstraintException:
            # Ignore duplicates
            pass


load_variables(matlab_data_variable_names)
print("Variables loaded successfully.")       

def load_sites(matlab_site_data):
    """
    Extracts site information from sitekey.mat and inserts it into the DuckDB database.
    Assumes that each agency is stored as a separate field in the .mat file (e.g., BoM, DBCA, etc.).
    """
    for key in matlab_site_data:
        if key.startswith('__'):
            continue  # Skip MATLAB metadata fields

        site_array = matlab_site_data[key]
        if not isinstance(site_array, np.ndarray):
            continue  # Skip non-structured entries

        # Iterate over all entries in the agency-specific array
        for i in range(site_array.shape[1]):
            entry = site_array[0, i]

            def safe_get(field):
                """
                Safely extract a field from the MATLAB struct, handling empty or missing data.
                """
                try:
                    val = entry[field]
                    if val.size > 0:
                        return val[0, 0] if val.ndim == 2 else val[0]
                except:
                    return None

            agency_tag = safe_get('Agency_Tag')
            site_id = safe_get('Site_ID')
            site_name = safe_get('Site_Name')
            latitude = float(safe_get('Latitude') or 0.0)
            longitude = float(safe_get('Longitude') or 0.0)

            try:
                con.execute("""
                    INSERT INTO sites (agency_tag, site_id, site_name, latitude, longitude)
                    VALUES (?, ?, ?, ?, ?)
                """, (str(agency_tag), str(site_id), str(site_name), latitude, longitude))
            except duckdb.ConstraintException:
                # Skip duplicates or constraint violations
                pass

    print("Sites loaded successfully.")

def load_variables(matlab_varkey_data):
    """
    Extract variable info from MATLAB .mat file and insert into the database.
    """
    varkey_raw = matlab_varkey_data['varkey']

    # Unpack the MATLAB struct (usually a 1x1 ndarray)
    if isinstance(varkey_raw, np.ndarray) and varkey_raw.size == 1:
        varkey_struct = varkey_raw[0, 0]
    else:
        varkey_struct = varkey_raw  # fallback if already unpacked

    variable_codes = list(varkey_struct.dtype.names)

    for var_code in variable_codes:
        var_data = varkey_struct[var_code][0, 0]

        tfv_name = var_data['tfvName'][0] if 'tfvName' in var_data.dtype.names else None
        tfv_units = var_data['tfvUnits'][0] if 'tfvUnits' in var_data.dtype.names else None
        tfv_conv = float(var_data['tfvConv'][0, 0]) if 'tfvConv' in var_data.dtype.names else 1.0

        try:
            con.execute("""
                INSERT INTO variables (variable_code, tfv_name, tfv_units, tfv_conv)
                VALUES (?, ?, ?, ?)
            """, (var_code, tfv_name, tfv_units, tfv_conv))
        except duckdb.ConstraintException:
            pass  # Ignore duplicates

print("Loading variables from varkey.mat ...")
load_variables(matlab_data_variable_names)
print("Variables loaded successfully.")

def load_sites(matlab_site_data):
    """
    Extract site information from MATLAB .mat file and insert into the database.
    """
    site_struct = matlab_site_data['sitekey'].item()
    site_codes = site_struct.dtype.names

    for site_code in site_codes:
        site_data = site_struct[site_code][0, 0]

        # Extract fields safely
        station_id = site_data['Station_ID'][0] if 'Station_ID' in site_data.dtype.names else None
        deployment = site_data['Deployment'][0] if 'Deployment' in site_data.dtype.names else None
        lat = float(site_data['Lat'][0, 0]) if 'Lat' in site_data.dtype.names else None
        lon = float(site_data['Lon'][0, 0]) if 'Lon' in site_data.dtype.names else None
        xutm = float(site_data['X'][0, 0]) if 'X' in site_data.dtype.names else None
        yutm = float(site_data['Y'][0, 0]) if 'Y' in site_data.dtype.names else None
        calc_smd = float(site_data['calc_SMD'][0, 0]) if 'calc_SMD' in site_data.dtype.names else None
        mah_d = float(site_data['mAHD'][0, 0]) if 'mAHD' in site_data.dtype.names else None

        # The site_code key here can be the same as site_code in DB
        # Retrieve agency_id from agency_code in site_data
        agency_code = site_data['Agency_Code'][0] if 'Agency_Code' in site_data.dtype.names else None
        agency_id = None
        if agency_code:
            agency = con.execute("SELECT agency_id FROM agencies WHERE agency_code = ?", (agency_code,)).fetchone()
            agency_id = agency[0] if agency else None

        # Construct a unique site_code string (e.g. tag_station_deployment)
        tag = site_data['Tag'][0] if 'Tag' in site_data.dtype.names else ''
        site_code_str = f"{tag}_{site_code}_{deployment}" if deployment else f"{tag}_{site_code}"

        try:
            con.execute("""
                INSERT INTO sites (site_code, agency_id, station_id, deployment, lat, lon, xutm, yutm, calc_smd, mah_d)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
            """, (site_code_str, agency_id, station_id, deployment, lat, lon, xutm, yutm, calc_smd, mah_d))
        except duckdb.ConstraintException:
            # Ignore duplicates
            pass

print("Loading sites from sitekey.mat ...")
load_sites(matlab_data_site_coordinates)
print("Sites loaded successfully.")

def load_measurements_from_csvs(csv_folder):
    """
    Lee todos los CSV de mediciones en la carpeta y los inserta en la tabla measurements.
    Se asume que cada CSV tiene columnas: site_code, variable_code, date, value, raw_value, depth, qc_code
    """
    csv_files = glob.glob(str(Path(csv_folder) / "*.csv"))
    for csv_file in csv_files:
        print(f"Procesando {csv_file} ...")
        df = pd.read_csv(csv_file)
        for _, row in df.iterrows():
            # Buscar site_id
            site_id = con.execute(
                "SELECT site_id FROM sites WHERE site_code = ?", (row['site_code'],)
            ).fetchone()
            if not site_id:
                print(f"Site code {row['site_code']} no encontrado, saltando fila.")
                continue
            # Buscar variable_id
            variable_id = con.execute(
                "SELECT variable_id FROM variables WHERE variable_code = ?", (row['variable_code'],)
            ).fetchone()
            if not variable_id:
                print(f"Variable code {row['variable_code']} no encontrado, saltando fila.")
                continue
            # Insertar medición
            try:
                con.execute("""
                    INSERT INTO measurements (
                        site_id, variable_id, date, value, raw_value, depth, qc_code
                    ) VALUES (?, ?, ?, ?, ?, ?, ?)
                """, (
                    site_id[0], variable_id[0], row['date'], row['value'],
                    row.get('raw_value', None), row.get('depth', None), row.get('qc_code', None)
                ))
            except duckdb.ConstraintException:
                # Ignorar duplicados
                pass
    print("Carga de mediciones completada.")

# Ejemplo de uso:
csv_folder = base_path / "csiem-data" / "code" # Cambia esto a tu carpeta real
# load_measurements_from_csvs(csv_folder)