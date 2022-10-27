clear all; close all;

[snum,sstr] = xlsread('../../../data-lake/site_key.xlsx','BOM','A2:H10000');

sitename = sstr(:,3);
siteid = snum(:,1);
Lat = snum(:,6);
Lon = snum(:,7);
shortname = sstr(:,4);

basedir = '../../../data-lake/bom/rainfall/';


i = 1;
url(i).name = 'http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dailyZippedDataFile&p_stn_num=9240&p_c=-17225282&p_nccObsCode=136&p_startYear=2022';i = i+1;

url(i).name = 'http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dailyZippedDataFile&p_stn_num=9256&p_c=-17284470&p_nccObsCode=136&p_startYear=2022';i = i+1;

url(i).name = 'http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dailyZippedDataFile&p_stn_num=9281&p_c=-17377155&p_nccObsCode=136&p_startYear=2022';i = i+1;

url(i).name = 'http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dailyZippedDataFile&p_stn_num=9053&p_c=-16541124&p_nccObsCode=136&p_startYear=2022';i = i+1;

url(i).name = 'http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dailyZippedDataFile&p_stn_num=9021&p_c=-16425451&p_nccObsCode=136&p_startYear=2022';i = i+1;

url(i).name = 'http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dailyZippedDataFile&p_stn_num=9225&p_c=-17169887&p_nccObsCode=136&p_startYear=2022';i = i+1;

url(i).name = 'http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dailyZippedDataFile&p_stn_num=9193&p_c=-17052012&p_nccObsCode=136&p_startYear=2022';i = i+1;

url(i).name = 'http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dailyZippedDataFile&p_stn_num=9215&p_c=-17133007&p_nccObsCode=136&p_startYear=2022';i = i+1;

url(i).name = 'http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dailyZippedDataFile&p_stn_num=9178&p_c=-16996899&p_nccObsCode=136&p_startYear=2022';i = i+1;

url(i).name = 'http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dailyZippedDataFile&p_stn_num=9172&p_c=-16974879&p_nccObsCode=136&p_startYear=2022';i = i+1;


http://www.bom.gov.au/jsp/ncc/cdio/weatherData/av?p_display_type=dataFile&p_stn_num=9172&p_nccObsCode=136

% 
for i = 1:length(url)
    
    options = weboptions('Timeout',Inf);
    

    theaddress = [url(i).name];
    
    
    try
        outfilename = websave('temp.zip',theaddress,options);
        
        unzip('temp.zip',basedir);
        
        
    catch
        % Continue on error
    end
    
    
end
    