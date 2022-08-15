function getBoMmetdata(sMetDir,header_file)
% Function to import the swan met data and save to a structured type
% swanmet.mat
% sMetDir is the file path in which the BoM data files are stored. Remember
% to add "\" at the end of the path!!!
% Add or remove headers under cHeader based on your data. Import of Date in
% the right format should be checked!

addpath(genpath('Headers'));
addpath(genpath('Functions'));


run(header_file);

dirlist = dir(sMetDir);

for iMet = 3:length(dirlist)
    
    disp(['Processing File ',num2str(iMet - 2)]);
    filename = [sMetDir,dirlist(iMet).name];
    fid = fopen(filename,'rt');
    
    
    
 
    x  = length(cHeader);
    textformat = [repmat('%s ',1,x)];
    datacell = textscan(fid,textformat,...
        'Headerlines',1,...
        'Delimiter',',');
    fclose(fid);
    
    for iHeader = 1:length(cHeader)
        sCompStrFull = cHeader{iHeader};
        sCompStr = sCompStrFull(end-2:end);
        
        %if strcmp(sCompStr,'_QC') == 0
            if strcmp(cHeader{iHeader},'Date') == 1
                met.(cHeader{iHeader}) = datenum(datacell{iHeader},'dd/mm/yyyy HH:MM');
            else
                met.(cHeader{iHeader}) = str2double(datacell{iHeader});
            end
        %end
        
    end
    
    
    nSiteID = met.StationID(1);
    
    
    met.Date = datenum(met.Year,met.Month,met.Day,met.Hour,met.MI_Format,00);
    
    vars = fieldnames(met);
    
    [~,uind] = unique(met.Date);
    
    for kgk = 1:length(vars)
        met.(vars{kgk}) = met.(vars{kgk})(uind);
    end
    
    
    [mdata,name]  = bom_sites(nSiteID,met);
    
    metdata.(name) = mdata.(name);
end

save metdata.mat metdata -mat -v7.3