# Please set the following variables to True to run the import pipeline for the desired datasets

import_nasa_ghrsst = True
import_nasa_modis = True

import_moi_nemo = True
import_moi_pisces = True
import_moi_seapodym = True

import_esa_globcolor = True
import_esa_sentinel = True

import_imos_soop = True

import_wamsi_wwmsp5_roms = True

import_csiro_srfme = True

import_dep_smcws = True

import_uwa_wawaves = True
import_uwa_cwr = True

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
    from import_py.NASA.importNASAGHRSST import import_nasa_ghrsst
    print(f"Working directory: {current_path.parent}")
    import_nasa_ghrsst(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_nasa_modis:
    print("Importing NASA MODIS")
    sys.path.append(str(CODE_DIR))
    from import_py.NASA.importNASAMODIS import import_nasa_modis
    import_nasa_modis(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_moi_nemo:
    print("Importing MOI NEMO")
    sys.path.append(str(CODE_DIR))
    from import_py.MOI.importMOINEMO import import_moi_nemo
    import_moi_nemo(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_moi_pisces:
    print("Importing MOI PISCES")
    sys.path.append(str(CODE_DIR))
    from import_py.MOI.importMOIPISCES import import_moi_pisces
    import_moi_pisces(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_moi_seapodym:
    print("Importing MOI SEAPODYM")
    sys.path.append(str(CODE_DIR))
    from import_py.MOI.importSEAPODYM import import_moi_seapodym
    import_moi_seapodym(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_esa_globcolor:
    print("Importing ESA GLOBCOLOR")
    sys.path.append(str(CODE_DIR))
    from import_py.ESA.importESAGLOBCOLOR import import_esa_globcolor
    import_esa_globcolor(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_esa_sentinel:
    print("Importing ESA SENTINEL")
    sys.path.append(str(CODE_DIR))
    from import_py.ESA.importESASENTINEL import import_esa_sentinel
    import_esa_sentinel(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_imos_soop:
    print("Importing IMOS SOOP")
    sys.path.append(str(CODE_DIR))
    from import_py.IMOS.importIMOSSOOP import import_imos_soop
    import_imos_soop(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_wamsi_wwmsp5_roms:
    print("Importing WAMSI WWMSP5 ROMS")
    sys.path.append(str(CODE_DIR))
    from import_py.WAMSI.importWAMSIWWMSP5ROMS import import_wamsi_wwmsp5_roms
    import_wamsi_wwmsp5_roms(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_csiro_srfme:
    print("Importing CSIRO SRFME")
    sys.path.append(str(CODE_DIR))
    from import_py.CSIRO.importCSIROSRFME import import_csiro_srfme
    import_csiro_srfme(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_dep_smcws:
    print("Importing DEP SMCWS")
    sys.path.append(str(CODE_DIR))
    from import_py.DEP.importDEPSMCWS import import_dep_smcws
    import_dep_smcws(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_uwa_wawaves:
    print("Importing UWA WAWAVES")
    sys.path.append(str(CODE_DIR))
    from import_py.UWA.importUWAWAWAVES import import_uwa_wawaves
    import_uwa_wawaves(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

if import_uwa_cwr:
    print("Importing UWA CWR")
    sys.path.append(str(CODE_DIR))
    from import_py.UWA.importUWACWR import import_uwa_cwr
    import_uwa_cwr(CODE_DIR,ACTIONS_DIR,base_path,matlab_data_conversion_data,matlab_data_variable_names,matlab_data_site_coordinates)
    print("Done")

print("Pipeline complete")
