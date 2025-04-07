# DWER CSPHYTO
This dataset is a phytoplankton dataset containing phytoplankton concentrations (in cells/mL)  in the form of an excel table (xlsx), it stores data with columns to describe details and a new entry in the table for each unique combination of column details.

## Phytoplankton Species Import
The species data from this dataset is imported with one script that reads in the excel document and iterates through all entries. It matches the phytoplankton nomenclature between our system and this dataset, likewise with the site names/Coordinates. Once matched these details are processed into our system.

## Phytoplankton Group Import
The group data is imported by two scripts. A staging script that creates a "holding"/"workingout" csv file for each combination of site and group, this file is appended with all of the data entries that have the same site and the same group, ie each species in the current group. This means that there are multiple rows associated with the same time value. Then the other script, the Staged script, runs through and finds duplicate time values and sums them to give the concentration of that entire group at that given time.