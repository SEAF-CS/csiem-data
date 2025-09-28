# CSV Folder
This folder contains more folders, these are agency folders and each agency folder contains data. This data is a collection of time series's together with its appropriate meta data. There are different variables and different locations that the variable has been measured/observed, for each combination of variable and site location pair, there exists three, comma seperated value (csv) files. All three files have the same base name but differ at their suffix:
The suffixes are:

DATA, HEADER or SMD.
## DATA
This is the file that contains the time series data, it has 4 fields:

### Date <a name="csv-data-date"></a>
The date is typically stored in the format yyyy-mm-dd HH:MM:SS, for more information see [Header/Date/](#csv-header-date).

### Depth or Height
This field describes the elevation an observation was made at, it can be measured from the sea surface, in which this heading is called Depth, or from the seabed, which is when it's called Height. This is measured in metres.

### Data
This is where the numerical value for the variable is stored, the units and other meta data can be found in the header file, for more information about the meta data stored in the header files see [Header](#csv-header)

### QC
This refers to if the data has had any Quality Control. 'N' for datasets/values that haven't been quality controlled and therefore 'Y' for datasets/values that have been Quality Controlled.



### Example
An example snippet from .../bmt/wp/swan/SWAN_AWAC1_Peak_Wave_Direction_DATA.csv can be seen below:

```csv
Date,Depth,Data,QC
2013-01-01 00:00:00,0.0000,265.6464,N
2013-01-01 01:00:00,0.0000,266.9652,N
2013-01-01 02:00:00,0.0000,267.4520,N
2013-01-01 03:00:00,0.0000,268.5586,N
2013-01-01 04:00:00,0.0000,268.8529,N
2013-01-01 05:00:00,0.0000,269.0981,N
```

## HEADER  <a name="csv-header"></a>
This is the file that contains the meta data for the data file. It has a structured format with the following feilds.
### Agency Name
This describes the name, in full, of the agency that is providing this data.
### Agency Code
This is the shorted name of the agency that is providing this data.
### Program
**A LITTLE BIT STUCK DONT FORGET TO REMOVE THIS TEMPORARY NOTE**
### Project
**A LITTLE BIT STUCK DONT FORGET TO REMOVE THIS TEMPORARY NOTE**
### Tag
Unique identifier for each of the datasets.
### Data File Name<a name="csv-header-datafilename"></a>
This is a historical field and is no longer used, it stores either the accompaniying datafile name or, the parent Datalake name, is accompanied by the [Location](#csv-header-location) field.
### Location <a name="csv-header-location"></a>
This is a historical field and is no longer used, it stores either the accompaniying datafile path or, the parent Datalake path, is accompanied by the [Data File Name](#csv-header-datafilename) field.
### Station Status
This is a hardcoded value that is used to determine if the site is still producing observations. Some datasets do not contain this information.
### Lat
This is the latitude of the site, in units of degrees.
### Long
This is the longitude of the site, in units of degrees.
### Time Zone
This is the timezone of the site relative to GMT.
### Vertical Datum
This is the vertical reference surface used, typically mAHD, which is the abbreviation for Australian Height Datum in metres.
### National Station ID
This is the name/id used to refer to the site.
### Site Description
This is mostly unused, but it is for providing extra information about a site.
### Deployment
This refers to which deployment type was/is used for observations, deployment type is important as it affects the point of reference and therefore elevation.
#### Integrated
This refers to a deplyment where the entire water column is collected and mixed to make an observation.
#### Fixed
This is tied to, and/or attatched/fixed to the seabed or another structure that's height and elevation won't change with tide and water movements.
#### Floating
This is tied to, and/or attatched to a float and hence the height and elevation will change with the tide and water movements.
#### Profile
This is sampled seperately at various depths, giving an observation at each sampled depth/height or elevation.
#### Satelite
This is sampled exclusively from a satelite and so will be a surface observation.
### Deployment Position <a name="csv-header-deploymentposition"></a>
This refers to the depth/height the observations are made at.
### Vertical Reference
This is the reference that the [deployment position](#csv-header-deploymentposition) uses. 
### Site Mean Depth  
This is not always updated, but provides the mean depth of all observations made at this site.
### Bad or Unavailable Data Value
This is the value that will appear in the time series if a value is bad or unavailable.
### Contact Email
This is the contact email for the person responsible for importing that dataset/variable and sometimes contains the date the import code was written.
### Variable ID
This is the id of the variable, which will exist in the master variable key.
### Data Category
This refers to the Category  that this variable belongs to, in the master variable key.
### Sampling Rate (min)
This is a historical field and was created to display the sampling period in minutes.
### Date <a name="csv-header-date"></a>
This is the format of the date in the [data file](#csv-data-date). This is using the old matlab standard for datenum variables which can be found at [https://au.mathworks.com/help/matlab/ref/datetime.datenum.html](https://au.mathworks.com/help/matlab/ref/datetime.datenum.html) or below (21/01/2025). Note the datenum, function/standard is no longer recommened and its sucsessor uses a different format.
| Symbolic Identifier                                          | Description                                 | Example         |
| ------------------------------------------------------------ | ------------------------------------------- | --------------- |
| yyyy                                                         | Year in full                                | 1990, 2002      |
| yy                                                           | Year in two digits                          | 90, 02          |
| QQ                                                           | Quarter year using letter Q and one digit   | Q1              |
| mmmm                                                         | Month using full name                       | March, December |
| mmm                                                          | Month using first three letters             | Mar, Dec        |
| mm                                                           | Month in one or two digits                  | 3, 06, 12       |
| m                                                            | Month using capitalized first letter        | M, D            |
| dddd                                                         | Day using full name                         | Monday, Tuesday |
| ddd                                                          | Day using first three letters               | Mon, Tue        |
| dd                                                           | Day in one or two digits                    | 5, 09, 20       |
| d                                                            | Day using capitalized first letter          | M, T            |
| HH                     | Hour in two digits (no leading zeros when symbolic identifier AM or PM is used)   | 05, 5 AM        |
| MM                                                           | Minute in two digits                        | 12, 02          |
| SS                                                           | Second in two digits                        | 07, 59          |
| FFF                                                          | Millisecond in three digits                 | 57              |
| AM or PM                                                     | AM or PM inserted in text representing time | 3:45:02 PM      |

### Depth
This is the data type that the depth is stored as.
### Variable
This is the variable name.
### QC
This is the data type that the QC value is stored as.

### Example
An example from .../bmt/wp/swan/SWAN_AWAC1_Peak_Wave_Direction_HEADER.csv can  be seen below:
```csv
Agency Name,British Mariner Technology
Agency Code,BMT
Program,WP
Project,SWAN
Tag,BMT-WP-SWAN
Data File Name,SWAN_AWAC1_Peak_Wave_Direction_DATA.csv
Location,GIS_DATA/csiem-data-hub/data-warehouse/csv/bmt/wp/swan
Station Status,
Lat,-32.079398000
Long,115.704160000
Time Zone,GMT +8
Vertical Datum,mAHD
National Station ID,SWAN_AWAC1
Site Description,SWAN_AWAC1
Deployment,Floating
Deployment Position,0.0m below Surface
Vertical Reference,m below Surface
Site Mean Depth,    
Bad or Unavailable Data Value,NaN
Contact Email,Lachy Gill <00114282@uwa.edu.au> 05/04/2024
Variable ID,var00281
Data Category,Hydrodynamics
Sampling Rate (min), NaN
Date,yyyy-mm-dd HH:MM:SS
Depth,Decimal
Variable,Peak Wave Direction
QC,String
```



## SMD
This is a calculated file that is used to create a standardised depth for each site.


# CSV Holding Folder
This folder is used to hold temporary files for when creating the main CSV files. 
# Data-images Folder
This is a folder of plotted time series data. This is one of the methods of validation, visualising a plot of the times series date.
# Mat Folder
This is one method of collating the data into one place. The matfiles are an auto generated files that contain the data from the CSV folder.
# Parquet Folder
This is one method of collating the data into one place. The parquet files are an auto generated files that contain the data from the CSV folder that use compression to reduce the file sizes.
# Stats Folder
This folder contains a stats file which is calculated based on the entire warehouse and basically lists all the meta data inside the headers files all in one place, this helps with header file uniformity and consistency.
