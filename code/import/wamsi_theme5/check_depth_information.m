clear all; close all;


rawadcp = tfv_readnetcdf('Y:\WAMSI\Theme 5\WAMSI_Westport_Theme5\November_2021\UWA_CS4_ADCP_2303.nc');
rawpar = tfv_readnetcdf('Y:\WAMSI\Theme 5\WAMSI_Westport_Theme5\November_2021\UWA_CS4_PAR_531189.nc');

mtimeadcp = datenum(1950,01,01,00,00,00) + rawadcp.TIME;
mtimepar = datenum(1950,01,01,00,00,00) + rawpar.TIME;

datestr(min(mtimeadcp))
datestr(max(mtimeadcp))

datestr(min(mtimepar))
datestr(max(mtimepar))