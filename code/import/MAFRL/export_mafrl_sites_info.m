clear all; close all;
addpath(genpath('../../functions/'));


load ../../actions/sitekey.mat;

sites = fieldnames(sitekey.mafrl);

fid = fopen('mafrl_sites.csv','wt');

for i = 1:length(sites)
    [lat,lon] = utm2ll(sitekey.mafrl.(sites{i}).X,sitekey.mafrl.(sites{i}).Y,-50);
    
    fprintf(fid,'%s,%s,%4.4f,%4.4f\n',sitekey.mafrl.(sites{i}).ID,sitekey.mafrl.(sites{i}).Description,lat,lon);
    
end
fclose(fid);