clear all; close all;

load ../../actions/sitekey.mat

xlsname = 'D:\Cloud\AED Dropbox\AED_Cockburn_db\CSIEM\Data\data-swamp\WC\WC-BMT\Digitised_DO.xlsx';


outdir = 'D:\csiem\data-warehouse\csv\wc\digitised\';mkdir(outdir);

%____________________________________________________________
mdata = [];ddata = [];data = [];

[snum,~] = xlsread(xlsname,'Southbuoy_surf','A2:B100');

mdata = calc_dates(snum(:,1));
ddata(1:length(mdata),1) = 0;
data = snum(:,2);
Lat = sitekey.wc.wc_southbuoy.Lat;
Lon = sitekey.wc.wc_southbuoy.Lon;
filename = 'WC_Digitised_SB_Oxygen_2013';
AgencyName = 'Water Corp';
AgencyCode = 'WC';
Program =  'BMT Digitisaed';
ProgramCode = 'WC_BMT';
SiteID = sitekey.wc.wc_southbuoy.ID;
SiteDesc = sitekey.wc.wc_southbuoy.Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________

mdata = [];ddata = [];data = [];

[snum,~] = xlsread(xlsname,'Southbuoy_bed','A2:B100');

mdata = calc_dates(snum(:,1));
ddata(1:length(mdata),1) = 20;
data = snum(:,2);
Lat = sitekey.wc.wc_southbuoy.Lat;
Lon = sitekey.wc.wc_southbuoy.Lon;
filename = 'WC_Digitised_SB_Oxygen_2013_Bottom';
AgencyName = 'Water Corp';
AgencyCode = 'WC';
Program =  'BMT Digitisaed';
ProgramCode = 'WC_BMT';
SiteID = sitekey.wc.wc_southbuoy.ID;
SiteDesc = sitekey.wc.wc_southbuoy.Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);



%____________________________________________________________
mdata = [];ddata = [];data = [];

[snum,~] = xlsread(xlsname,'Centralbuoy_surf','A2:B100');

mdata = calc_dates(snum(:,1));
ddata(1:length(mdata),1) = 0;
data = snum(:,2);
Lat = sitekey.wc.wc_centralbuoy.Lat;
Lon = sitekey.wc.wc_centralbuoy.Lon;
filename = 'WC_Digitised_CB_Oxygen_2013';
AgencyName = 'Water Corp';
AgencyCode = 'WC';
Program =  'BMT Digitisaed';
ProgramCode = 'WC_BMT';
SiteID = sitekey.wc.wc_centralbuoy.ID;
SiteDesc = sitekey.wc.wc_centralbuoy.Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________

mdata = [];ddata = [];data = [];

[snum,~] = xlsread(xlsname,'Centralbuoy_bed','A2:B100');

mdata = calc_dates(snum(:,1));
ddata(1:length(mdata),1) = 20;
data = snum(:,2);
Lat = sitekey.wc.wc_centralbuoy.Lat;
Lon = sitekey.wc.wc_centralbuoy.Lon;
filename = 'WC_Digitised_CB_Oxygen_2013_Bottom';
AgencyName = 'Water Corp';
AgencyCode = 'WC';
Program =  'BMT Digitisaed';
ProgramCode = 'WC_BMT';
SiteID = sitekey.wc.wc_centralbuoy.ID;
SiteDesc = sitekey.wc.wc_centralbuoy.Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________
mdata = [];ddata = [];data = [];

[snum,~] = xlsread(xlsname,'Northbuoy_surf','A2:B100');

mdata = calc_dates(snum(:,1));
ddata(1:length(mdata),1) = 0;
data = snum(:,2);
Lat = sitekey.wc.wc_northbuoy.Lat;
Lon = sitekey.wc.wc_northbuoy.Lon;
filename = 'WC_Digitised_NB_Oxygen_2013';
AgencyName = 'Water Corp';
AgencyCode = 'WC';
Program =  'BMT Digitisaed';
ProgramCode = 'WC_BMT';
SiteID = sitekey.wc.wc_northbuoy.ID;
SiteDesc = sitekey.wc.wc_northbuoy.Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);

%____________________________________________________________

mdata = [];ddata = [];data = [];

[snum,~] = xlsread(xlsname,'Northbuoy_surf','A2:B100');

mdata = calc_dates(snum(:,1));
ddata(1:length(mdata),1) = 20;
data = snum(:,2);
Lat = sitekey.wc.wc_northbuoy.Lat;
Lon = sitekey.wc.wc_northbuoy.Lon;
filename = 'WC_Digitised_NB_Oxygen_2013_Bottom';
AgencyName = 'Water Corp';
AgencyCode = 'WC';
Program =  'BMT Digitisaed';
ProgramCode = 'WC_BMT';
SiteID = sitekey.wc.wc_northbuoy.ID;
SiteDesc = sitekey.wc.wc_northbuoy.Description;

write_files(mdata,ddata,data,...
    filename,AgencyName,AgencyCode,...
    Program,ProgramCode,outdir,Lat,Lon,...
    SiteID,SiteDesc);
