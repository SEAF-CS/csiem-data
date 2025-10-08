csiem_data_paths
master.fielddata_files = {'csiem_WAMSI_public',};

master.varname = {...
'WQ_DIAG_TOT_TURBIDITY','Turbidity';...
};

timeseries.start_plot_ID = 1;
timeseries.end_plot_ID = 1;
timeseries.polygon_file = [marvldatapath,'/gis/Zones/MLAU_Zones_v3_ll.shp'];
timeseries.outputdirectory = [marvldatapath,'/outputs/fast/'];
timeseries.htmloutput = [marvldatapath,'/outputs/fast/HTML/'];
