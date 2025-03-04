# WAMSI Theme 1.1
## WRF
This data set is imported via the matlab script ImportWRF.m. It is a numerically calculated dataset from created from data of pre-existing sites. This data set has been imported but the variables havent been formally processed so they have the default header name as variable names. This dataset has a calclulated variablet hat doesnt appear in the raw data, precipitation rate, which is the rate of change of the precipitation.

### Raw Data
This data is imported straight from the data lake in the form of csv's. There is one csv per site.

### Variables
 - Air Pressure
 - Photosynthetically Active Radiation
 - longwave radiation
 - Precipitation
 - Precipitation Rate
 - Air Temperature
 - Specific humidity at 2m height
 - Sensible heat flux
 - Latent heat flux 
 - sea surface temperature
 - Relative Humidity
 - eastern wind speed at 10 m height
 - northern wind speed at 10 m height
 - Wind Speed
 - Wind Direction
 - Cloud Cover
 - RAINV

### Conversions
![Variable Conversion Table](./WWMSP%20WRF%20Conversions.png)

### Import Code
This code matches the site based off which csv is being opened, then iterates through the variables matching those and processing the data. Additionally the code also takes the derivitive of the precipitation so that it can get the precipitation rate.

