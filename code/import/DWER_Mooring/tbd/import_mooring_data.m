clear all; close all;

addpath(genpath('../../functions/'));

filepath = 'V:/data-lake/dwer/csmooring/';

filelist = dir(fullfile(filepath, '**\*.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


% Mapping.

% filename = '../../../data-mapping/DWER_CSMOORING.csv';
% 
% [snum,sstr] = xlsread(filename,'A2:i100');
% 
% stationID = snum(:,1);
% lat = snum(:,3);
% lon = snum(:,4);
% 
% [X,Y] = ll2utm(lat,lon);

% Conversion
% [snum,sstr] = xlsread('Conversions_mh.xlsx','A2:D1000');

load ../../actions/agency.mat;
load ../../actions/sitekey.mat;

sitelist = fieldnames(sitekey.dwermooring);
varlist = fieldnames(agency.dwermooring);

% oldheader = sstr(:,1);
% newheader = sstr(:,3);
% conv = snum(:,1);

mooring = [];


for i = 1:length(filelist)
    
    disp(filelist(i).name);
    
    filename = [filelist(i).folder,'/',filelist(i).name];
    
    fid = fopen(filename,'rt');
    
    fline = fgetl(fid);
    
    sites = split(fline,',');
    
    thesite = str2num(regexprep(sites{3},'"',''));
    
    
    
    sitestr = ['s',num2str(thesite)];
    
    
    for ii = 1
    
    
    fline = fgetl(fid);
    hline = fgetl(fid);
    
    headers = split(hline,',');
    headers = regexprep(headers,'"','');
    fclose(fid);
    fid = fopen(filename,'rt');
    
    x  = length(headers);
    textformat = [repmat('%s ',1,x)];
    % read single line: number of x-values
    datacell = textscan(fid,textformat,'Headerlines',5,'Delimiter',',');
    fclose(fid);
    
    
    mdate = datenum(datacell{1},'HH:MM:SS dd/mm/yyyy');
    
    theint = find(stationID == thesite);
    
    
    
    
    for j = 2:length(headers)
        
        sss = find(strcmpi(oldheader,headers{j}) == 1);
        
        if isempty(sss)
            stop
        else
            
            thedata = str2double(datacell{j});
            
            
            if ~isempty(thedata)
                
                mooring.(sitestr).(newheader{sss}).Date(:,1) = mdate;
                mooring.(sitestr).(newheader{sss}).Data(:,1) = thedata * conv(sss);
                mooring.(sitestr).(newheader{sss}).Depth(1:length(mdate),1) = 0;
                mooring.(sitestr).(newheader{sss}).X = X(theint);
                mooring.(sitestr).(newheader{sss}).Y = Y(theint);
                mooring.(sitestr).(newheader{sss}).Title = sitestr;
                mooring.(sitestr).(newheader{sss}).Variable_Name = headers{j};
                mooring.(sitestr).(newheader{sss}).Units = '';
            else
                disp(['Empty Var: ',headers{j}]);
            end
                
        end
    end
               
end



sites = fieldnames(mooring);

for i = 1:length(sites)
    
    vars = fieldnames(mooring.(sites{i}));
    
    for j = 1:length(vars)
        
        td = mooring.(sites{i}).(vars{j}).Date;
        tdt = mooring.(sites{i}).(vars{j}).Data;
        tdd = mooring.(sites{i}).(vars{j}).Depth;
        
        sss = find(~isnan(tdt) == 1);
        
        if ~isempty(sss)
            mooring.(sites{i}).(vars{j}).Date = td(sss);
            mooring.(sites{i}).(vars{j}).Data = tdt(sss);
            mooring.(sites{i}).(vars{j}).Depth = tdd(sss);
        else
            mooring.(sites{i}) = rmfield(mooring.(sites{i}),vars{j});
        end
    end
end

save mooring.mat mooring -mat;
        
load swan.mat;

for i = 1:length(sites)
    
    if ~isfield(swan,sites{i})
        swan.(sites{i}) = mooring.(sites{i});
    else
        stop;
    end
end
save swan_new.mat swan -mat;
        
        




