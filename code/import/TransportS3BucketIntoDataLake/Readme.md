# General s3 Bucket Import Code
This code both import ands transfers latest copy of data from s3 bucket into davy data lake and data warehouse

This code can be used to import all the folders specifed here
- wamsi-westport-project-1-1/csiem-data/data-lake/UKMO
- wamsi-westport-project-1-1/csiem-data/data-lake/NASA
- wamsi-westport-project-1-1/csiem-data/data-lake/MOI
- wamsi-westport-project-1-1/csiem-data/data-lake/ESA

## Dependencies
    Each Folder has a corresponding import (unless still in development), The individual import code depends on this (the transport) code to collect the most recent version from s3 and vice versa, this code in order to import relies on the indivudal import code. 2 way dependance.
## UMKO
[UKMO Readme](../UKMO/Readme.md)