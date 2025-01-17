import re

def get_datapath_from_matlab(ACTIONS_DIR,base_path):
    matlab_file = str(ACTIONS_DIR / 'csiem_data_paths.m')
    with open(matlab_file, 'r') as f:
        content = f.read()
        # Find the first datapath assignment with single quotes
        match = re.search(r"datapath\s*=\s*'([^']*)'", content)
        if match:
            print(match.group(1).strip("/"))
            return str(base_path / match.group(1).strip("/")),match.group(1).strip("/")
        raise ValueError("Could not find datapath in MATLAB file")
    
def get_conversion_data(dataset,matlab_data_conversion_data):
    agency_data = matlab_data_conversion_data['agency'][dataset][0, 0]
    return agency_data

def get_variable_names(Id,matlab_data_variable_names):
    varkey_data = matlab_data_variable_names['varkey'][Id][0,0]
    return varkey_data

def get_site_coordinates(site_dataset,matlab_data_site_coordinates):
    site_coordinates_data = matlab_data_site_coordinates['sitekey'][site_dataset][0,0]
    return site_coordinates_data