# IMOS Phyto Plankton Species
This is a Phyto plankton dataset. This dataset is a phytoplankton dataset containing phytoplankton species concentrations (in cells/L)  in the form of a table/csv document, it stores data with columns to describe details and a new entry in the table for each unique combination of column details.

There are alot of variables in this dataset, so its quicker to list the variables that appear in the raw data that we are not importing.

## Variables in the dataset not imported
    Variables that have not been imported, this is likely because they are not phyto plankton.
    - Acantharia
    - Actinopoda
    - Choanoflagellatea
    - Ciliate (Inc. tintinnid)
    - Ciliate (naked 25-50 ␦m)
    - Ciliate (naked < 25␦m)
    - Ciliate 100-150 ␦m naked
    - Ciliate 50-60 ␦m
    - Codonella cf. galea
    - Codonella spp.
    - Codonellopsis cf. ostenfeldi
    - Codonellopsis morchella
    - Codonellopsis orthoceras
    - Codonellopsis pusilla
    - Codonellopsis spp.
    - Foraminifera
    - Gephyrocapsa  oceanica
    - Globigerinidae
    - Neogloboquadrina pachyderma
    - Pinus pollen
    - Protorhabdonella simplex
    - Protorhabdonella spp.
    - Radiolarian
    - Rotalia spp.
    - Strombidiidae
    - Strombidium spp.
    - Tintinnidium spp.
    - Tintinnina
    - Tintinnopsis radix
    - Tintinnopsis spp.
    - Tintinnopsis tocantinensis
    - Unid heterotroph 10-20 ␦m
    - Unid heterotroph 20-30 ␦m
    - Vorticella spp.
    - cf. Strombidium spp.
    - hairy flap
    - unid square cells

    This list gets produced in a text file when you run Species code. It also now gets appended with the groups that arent imported.
    
## Gephyrocapsa oceanica
    This variable appears twice in the dataset, It appears in the above list with the double spacing. The first time it is mentioned in the dataset it has a double space, the second time is single space. In both cases all entries are zero, hence it is only included once, using the single spaced version.

## Import
This code iterates through the columns and rows of the dataset and matches the phytoplankton names and sites with our system and processes them.

# IMOS Phyto Plankton Group
This is a Phyto plankton dataset. This dataset is a phytoplankton dataset containing phytoplankton group concentrations (in cells/L)  in the form of a table/csv document, it stores data with columns to describe details and a new entry in the table for each unique combination of column details.
## Variables

     - Bacillariophyta
     - Cyanophyta
     - Dinophyta
     - Other
     - Bacillariophyta
     - Ochrophyta

## Import
This code creates a temporary/"holding" csv file for each combination of site and group matched with our system. This file is then appeneded to as it iterates through the datafile. his file contains the all data entries, of each species in this group. This means that their are multiple rows associated with the same time value. Then the other script runs through and finds duplicate time values and adds them to give the concentration of that group at that given time, and then moves all of the files into the correct "csv" directory once they have been collated.