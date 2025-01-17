clear all; close all;

load metdata.mat;

sites = fieldnames(metdata);

for i = 1:length(sites)
    writeTFVMetcsv(datenum(2015,01,01),datenum(2022,04,01),7.5,sites{i},'PERTH_AIRPORT','Clouds');
    
    outputdir = ['Output/',sites{i},' met output'];
    
    rainfile = [outputdir,'/','tfv_rain_',sites{i},'.csv'];
    metfile = [outputdir,'/','tfv_met_',sites{i},'.csv'];
    imagefile = [outputdir,'/',sites{i},'.csv'];
    
    
    tfv_plot_met_infile(metfile,rainfile,imagefile);
    
end