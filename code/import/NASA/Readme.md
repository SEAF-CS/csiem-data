# NASA GHRSST SST
This dataset contains sea surface temperature data. This data exists as point data (a single latitude and longitude) but also as polygon data (which has a region of latitudes and longitudes and not just a single point in space).

## Raw Data
This data is collected by pythons script and stored in an s3 bucket. This data gets pulled down from the s3 by the script "TransportS3BucketIntoDataLake/TransportS3BucketIntoDataLake.py" and gets stored into the data lake.
This data contains time, Lat, Lon and the temp data in a csv. There is a csv for each site.

## Variables
- Temperature
- 
## Import Code
Because this data set is all the same variable it has been hardcoded, but it verifies that the variable is what it expects otherwise it errors, so should atleast not be a silent error if the code stops working.

It then reads in all of the csv's (one for each site), matches the site to our sitekey. then processes the variable.