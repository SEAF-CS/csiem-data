# Zoo Plankton Import
This dataset consists of zoo plankton concetrations across 15 sites
## Raw Data
The rows of this data are the various species name with the last few rows being "group" data, the reference to group is not necessarily the taxonomical use of the word, it is a collection speficially for the modelling. The columns of this data contain are the unique pairs of Site and Date, there are 15 unique sites and 12 dates making 180 columns.

## Import
This code matches the rows name with the name in our variable key, both species and group are together in the same varkey sheet (In  every other plankton import they are seperate) once it has matched the variable the site is matched and the dates are found and that variable is processed