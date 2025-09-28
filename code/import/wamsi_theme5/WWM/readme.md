# WAMSI Theme 5.2 WWM
## Raw data
Raw data is in the form of csvs seperated into WWM and WWM_REG folders

## Issues 
The CSV structure for all files is:
-Date,X,Y,HS,DM,TPP

However for the site JPPL:
-Date,X,Y,WVHT,WVDIR,WVPER

So I just changed the file myself to match (easier than coding in an exception, at the expense of modifying what the agency has provided)

Note. I got confused and mislabelled this dataset as WWMSP5 Waves, which caused a double up of nomenclature when I was presented with the real 5 Waves, I am pretty sure ive fixed the naming but read with caution.

## Conversions
![Conversion table](./Wamsi%20WWM%20Conversions.png)