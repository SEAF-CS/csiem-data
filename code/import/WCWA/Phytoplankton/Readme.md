# Water Corporation Western Australia Phyto 1
    Due to the sequential nature of this dataset, the header file as well as the heading of the data file must be created inside an " if exist()" statement then appended to for every other row.
    This dataset comes from an xlsx with sheets for both species and groups.

# Water Corporation Western Australia Phyto 2
This dataset came in an xls and is not super clear, they have a detection limit of 222, yet frequently have "cell count" in the thousands.
This dataset/spreadsheet has blank cells as well as cells with 0. The cells with nothing have been filtered out, however visually there is no difference between the 0 cells and th enothing ones so potenitally even the 0 cells should be removed, but just incase they have been left in.
The Species and Groups get processed seperately. In the spreadsheet they are mixed in with each other, with the Groups being bolded. The codebase compares the name with the list of either Groups or Species, if it isnt in the list it gets skipped. Hence groups dont get processed in the Species code.

# Water Corporation Western Australia Phyto 3-9
All of these are different sheets of the same document, these are all imported by 3 scripts, one script that imports all of the Species and a two stage script that imports the groups-> first that gets all the species from the group, then the next script adds all the entries that have the same date.
Depending on the needs I have also written a bash script that grabs WCWA3-9 and joins their files together, because i suspect that was the intention. But they had been seperated when describing the import.
