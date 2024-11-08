# Please set the following variables to True to run the import pipeline for the desired datasets

import_nasa_ghrsst = True
import_nasa_modis = True

#________________________________________________________________________________________#
# IMPORTING SCRIPTS
#________________________________________________________________________________________#

from pathlib import Path
from scipy.io import loadmat

# Define the base directory
current_path = Path(__file__).absolute()
root_path = next(p for p in current_path.parents if p.name == "GIS_DATA")
base_path = root_path.parent.absolute()
ACTIONS_DIR = base_path / 'GIS_DATA' / "csiem-data-hub" / "csiem-data" / "code" / "actions"
CODE_DIR = base_path / 'GIS_DATA' / "csiem-data-hub" / "csiem-data" / "code"

print("Load MATLAB data:")
print("Loading agency.mat") 
matlab_data_conversion_data = loadmat(str(ACTIONS_DIR / 'agency.mat'))
print("Loading varkey.mat")
matlab_data_variable_names = loadmat(str(ACTIONS_DIR / 'varkey.mat'))
print("Loading sitekey.mat")
matlab_data_site_coordinates = loadmat(str(ACTIONS_DIR / 'sitekey.mat'))
print("Done")

import sys

print("Execute import pipeline:")
if import_nasa_ghrsst:
    print("Importing NASA GHRSST")
    sys.path.append(str(CODE_DIR))
    from import_py.importNASAGHRSST import import_nasa_ghrsst
    print(f"Working directory: {current_path.parent}")
    import_nasa_ghrsst(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_nasa_modis:
    print("Importing NASA MODIS")
    sys.path.append(str(CODE_DIR))
    from import_py.importNASAMODIS import import_nasa_modis
    import_nasa_modis(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

print("Pipeline complete")