# UKMO
This dataset contains water surface temperature and spans from 01/01/2007 to Present. It contains indivudal point data and Polygon data of temperature over a region.

## TODO 
    The import does not currently import the polygon data
## How to Run
    This data can be imported in 2 ways.
    - The first is by calling "python3 ImportUKMO" (or python, depending on your version)
    - Or By running all of the s3 code at once, In Transports3BucketIntoDataLake
## Depencies
    The import code depends on a function that I wrote into the script "import/TransportS3BucketIntoDataLake/TransportS3BucketIntoDataLake.py", the function that I import collects the root path of this system. 

    Python Packages
    Pandas
    Scipy
    Boto3
## Raw Data
This data is copyied from the S3 Datalake into Davy datalake, in the form of csv's.
## Variables
 - sea surface temperature

