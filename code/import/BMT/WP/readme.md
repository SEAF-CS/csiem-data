# BMT SWAN Data Import

This site data is numerically simulated using data from sites we already have. We have three variables being imported in this code.

## Variables

-Peak Wave Direction
-Peak Wave Period
-Significant Wave Height

## Raw Data

This import code reads in from a structured matlab file. This file is a tiered structure, the top layer of the structure are site locations, then the variables measured/calculated at that site. Then the last layer contains the value, date and position of the site. This structure also contains sites from another organisation that we didnt want imported.

## Site matching

This code import uses longitude and latitude to match sites

## Conversions
![Variable Conversion Spreadsheet](./BMT%20Swan%20Conversions.png)
