csiem_data_paths
master.fielddata_files = {'csiem_DEP_public',};

master.varname = {...
'Light_Attenuation_Coefficient_6m','Light Attenuation Coefficient (6m)';...
'WQ_DIAG_TOT_EXTC','Light Attenuation Coefficient';...
};

timeseries.start_plot_ID = 1;
timeseries.end_plot_ID = 2;
timeseries.polygon_file = [datapath,'marvl/gis/DWER_zone2.shp'];
timeseries.outputdirectory = [datapath,'/marvl-images/fast/'];
timeseries.htmloutput = [datapath,'/marvl-images/fast/HTML/'];
