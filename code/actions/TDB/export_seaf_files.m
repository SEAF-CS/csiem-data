clear all; close all;


runlocal = 0;
if ~runlocal
    
    load('V:/data-warehouse/mat/seaf.mat');
    
    outdir = 'V:/data-warehouse/marvl/';
else
    load('Y:/csiem/data-warehouse/mat/seaf.mat');
    
    outdir = 'Y:/csiem/data-warehouse/marvl/';
end

load varkey.mat;



sites = fieldnames(seaf);

for i = 1:length(sites)
    
    vars = fieldnames(seaf.(sites{i}));
    
    for j = 1:length(vars)
        
        fulldir = [outdir,seaf.(sites{i}).(vars{j}).Agency_Code,'/',seaf.(sites{i}).(vars{j}).Program_Code,'/'];
        
        
        if ~exist(fulldir,'dir')
            mkdir(fulldir);
        end
        
        thevar = regexprep(varkey.(seaf.(sites{i}).(vars{j}).Variable_ID).Name,' ','_');
        
        filename = [fulldir,seaf.(sites{i}).(vars{j}).Agency_Code,'_',seaf.(sites{i}).(vars{j}).Station_ID,'_',thevar,'.csv'];
        
        fid = fopen(filename,'wt');
        
        datatype = fieldnames(seaf.(sites{i}).(vars{j}));
        
        disp(['Printing: ',filename]);
        
        
        for k = 8:length(datatype)
            if isnumeric(seaf.(sites{i}).(vars{j}).(datatype{k}))
                seaf.(sites{i}).(vars{j}).(datatype{k}) = num2str(seaf.(sites{i}).(vars{j}).(datatype{k}));
            end
            
            fprintf(fid,'# %s,%s\n',regexprep(datatype{k},'_',' '),seaf.(sites{i}).(vars{j}).(datatype{k}));
            
        end
        
        fprintf(fid,'# QC,%s\n',seaf.(sites{i}).(vars{j}).QC);
        
        fprintf(fid,'\n');
        fprintf(fid,'Date,Depth,Data\n');
        
        for k = 1:length(seaf.(sites{i}).(vars{j}).Date)
            fprintf(fid,'%s,%4.4f,%4.4f\n',datestr(seaf.(sites{i}).(vars{j}).Date(k),'dd-mm-yyyy HH:MM:SS'),seaf.(sites{i}).(vars{j}).Depth(k),...
                seaf.(sites{i}).(vars{j}).Data(k));
        end
        fclose(fid);
    end
end











