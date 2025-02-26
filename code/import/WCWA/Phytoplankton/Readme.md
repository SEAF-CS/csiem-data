# Water Corporation Western Australia Phyto 1
Due to the sequential nature of this dataset (variables all in a vertical list with multiple entires for different dates
), the header file as well as the heading of the data file must be created inside an " if exist()" statement then appended to for every other row. (as aposed to a column for every variable and rows for dates)
This dataset comes from an xlsx with sheets for both species and groups.

# Water Corporation Western Australia Phyto 2
This dataset came in an xls and is not super clear, they have a detection limit of 222, yet frequently have "cell count" in the thousands.
This dataset/spreadsheet has blank cells as well as cells with 0. The cells with nothing have been filtered out, however visually there is no difference between the 0 cells and the nothing ones so potenitally even the 0 cells should be removed, but just incase they have been left in.
The Species and Groups get processed seperately. In the spreadsheet they are mixed in with each other, with the Groups being bolded. The codebase compares the name with the list of either Groups or Species, if it isnt in the list it gets skipped. Hence groups dont get processed in the Species code.

# All North xls file for data collection sites that are "North"
This is one phytoplankton dataset that has different structures inside the one document.

## Water Corporation Western Australia Phyto 3-9
All of these are different sheets of the same document, these are all imported by 3 functions these functions are then called for each number by "RunALL.m", one function that imports all of the Species and a two stage functions that imports the groups-> first that gets all the species from the group, then the next function adds all the entries that have the same date and variable (a staging process, and then a process for once its staged).
Depending on the needs I have also written a bash script that grabs WCWA3-9 and joins their files together, because i suspect that was the intention. But they had been seperated when describing the import. This code also creates text files that were used for debugging just to makes sure that all the variables we wanted were actually being matched. 

## Water Corporation Western Australia Phyto 10-15
This is the second structure in the sheets, it is imported by four scripts. A staging script and a staged script for Species and also Group. The staging script goes through the sheets of the document that match the structure and grabs every data value and date and saves it to a text file with the same name as the variable (that appears in the spreadsheet, not the variable name that matches our systems variable names). These files are saved into the directory called csv_holding. These files are then read in with the purpose of matching document varnames with our system varnames. After this the data is written to the "csv" directory with the appropriate meta data. Reading in from the xls, the data positons have been hard coded into the code, as writting code that can accurately attain this information would take longer than simply hardcoding. So its not future proof but it works.


# All South xls file for data collection sites that are "South"
This is one phytoplankton dataset that has different structures inside the one document. (All south has the same document structure as "All North.xls", ie it has 2 seperate structures that match the two structures in All north)

## Water Corporation Western Australia Phyto 16-22
This code imports data that is in the same format as 3-9, however I redesigned the code, so it has very little in common with 3-9. This code processes each sheet (fitting the structure) in the document with the sheet name and size of the table being hardcoded. This was faster to code, than something more sophisticated, that searches each sheet to determine if it has the correct structure to be imported, then searching for the end of the table. The only differences between the Species import and the Group import is the output directory and the Agency structure it accesses (there is different sheet in the master key for group and species)


## Water Corporation Western Australia Phyto 23-28
This code is structured the exact same as 10-15 with appropriate changes (hardcoded data locations, datapaths, site locations).

# Bunbury Sites
This is been named Bunbury sites as of the 4 data files listed below, All contain the same sites, however only one calls these sites Bunbury, but given they are the same sites, it is assumed that they are Bunbury sites. Each of the 4 files had the same structure
## Water Corporation Western Australia Phyto 29-31
These codes all have their own import codes however they are all structured the exact same, just with different information hardcoded. They each only import one sheet from a document (each sheet contains different sites).


