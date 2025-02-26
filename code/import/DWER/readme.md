# DWER WIR Data Import

## Data Export

All data is exported from the WIR website, in small blocks. Data needs to be exported as either "Water Quality Discrete For Site CrossTab" or "Water Levels Continuous For Site CrossTab".

Three scripts need to be run in order:

- run_WIR_import.m: Creates the basic *.mat file
- export_wir_v2_stage1.m: Produces a flatfile of all data to allow for easy data classification
- import_and_reformat_flatfile.m: Produces the final csv file output.

All these scripts take a long time to run and produce the final output. Currently there is 4.1M data points which require a high degree of manipulation to fit the required data formats.


# DWER CSPHY
See the read me in the [DWER CSPHY directory](./CSPHY/Readme.md).

# DWER SWANESTPHY
See the read me in the [DWER SWANESTPHY directory](./SWANESTPHY/Readme.md)