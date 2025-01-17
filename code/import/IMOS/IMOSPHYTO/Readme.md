# IMOS Phyto Plankton Species
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
    This variable appears twice in the dataset, It appears in the above list with the double spacing. The first time it is mentioned in the dataset it has a double space, the second time is single space. In both cases all entries, hence it is only included once, using the single spaced version.

# IMOS Phyto Plankton Group
    Creates a holding csv file for each combination of site and group, this file contains the all data points, of each species in this group. This means that their are multiple rows associated with the same time value. I then I run another script that runs through and finds duplicate time values and adds them to give the concentration of that group at that given time.