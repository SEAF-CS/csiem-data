clear all; close all;
load swan.mat;

addpath(genpath('../../functions'));

plotdir = 'Images/';mkdir(plotdir);


sites = fieldnames(swan);
pt = [];
for i = 1:length(sites)
    vars = fieldnames(swan.(sites{i}));
    for j = 1:length(vars)
        
        thedepths = swan.(sites{i}).(vars{j}).Depth;
        
        for k = 1:length(thedepths)
                switch swan.(sites{i}).(vars{j}).Sample_Type{k}
                    
                    case 'Standard sample (Bottom)'
                        disp('bottom');
                        swan.(sites{i}).(vars{j}).Depth_Chx(k) = {'20'};
                        
                    case 'Standard sample (Surface)'
                        disp('surface');
                        swan.(sites{i}).(vars{j}).Depth_Chx(k) = {'0'};
                    otherwise
                        %swan.(sites{i}).(vars{j}).Depth(k) = 0;
                end
            end
        end
 
        
end

% for i = 1:length(sites)
%     vars = fieldnames(swan.(sites{i}));
%     if isfield(swan.(sites{i}),'WQ_var00134') & ~isfield(swan.(sites{i}),'WQ_var00006')
%         swan.(sites{i}).WQ_var00006 = swan.(sites{i}).WQ_var00134;
%         
%         swan.(sites{i}).WQ_var00006.Data = cond2sal(swan.(sites{i}).WQ_var00134.Data);
%         
%         swan.(sites{i}).WQ_var00006.Variable_name = 'Salinity';
%         swan.(sites{i}).WQ_var00006.Units = {'psu'};
%         
%     end
%     
% end


        
        

%unique(pt)

%stop;



tic

[snum,sstr] = xlsread('../../actions/Projects.xlsx','A2:D10000');

for k = 1:length(snum(:,1))
    thesites{k} = num2str(snum(k,1));
end
theproject = sstr(:,1);


[snum,sstr] = xlsread('../../../data-governance/variable_key.xlsx','MASTER KEY','A2:D10000');

varID = sstr(:,1);
varName = sstr(:,2);
varUnit = sstr(:,3);
varSymbol = sstr(:,4);

for i = 1:length(varSymbol)
    if isempty(varSymbol{i})
        varSymbol(i) = varName(i);
    end
end

outputdir = 'D:\csiem/data-warehouse/csv/dwer/swanest/';

sites = fieldnames(swan);

for i = 1:length(sites)
    %outdir = [outputdir,sites{i},'/'];
    
    schx = regexprep(sites{i},'s','');
    
        sss = find(strcmpi(thesites,schx)==1);
    
    
    if ~isempty(sss)
        
        proj = theproject{sss};
        oldproj = 'swanest';
        %header.Project = proj;
        %newfile = regexprep(newfile,lower(oldproj),lower(proj));
        outdir = regexprep(outputdir,lower(oldproj),lower(proj));
        if ~exist(outdir,'dir')
            mkdir(outdir);
        end
    else
        stop
        proj = 'swanest';
        outdir = [outputdir];
        if ~exist(outdir,'dir')
            mkdir(outdir);
        end    
    end
    
    
    

    
    vars = fieldnames(swan.(sites{i}));
    
    for j = 1:length(vars)
        
        varspt = split(vars{j},'_');
        ID = varspt{2};
        
        sss = find(strcmpi(varID,ID) == 1);
        
        thevar = varName{sss};
        
        
        %disp([sites{i},': ',thevar]);
        
        thevar_filename = regexprep(thevar,'(','');
        thevar_filename = regexprep(thevar_filename,')','');
        thevar_filename = regexprep(thevar_filename,' ','_');
        thevar_filename = regexprep(thevar_filename,'-','_');
        
        filename = [outdir,regexprep(sites{i},'s',''),'_',thevar_filename,'_DATA.csv'];
        
        fid = fopen(filename,'wt');
        
        var_full = [thevar,'(',varUnit{sss},')'];
        
        fprintf(fid,'Date,Depth,%s,QC\n','Data');
        
        for k = 1:length(swan.(sites{i}).(vars{j}).Date)
            
            bfg = swan.(sites{i}).(vars{j}).Depth_Chx{k};
            if isnan(bfg)
                %stop
                switch swan.(sites{i}).(vars{j}).Sample_Type{k}
                    
                    case 'Standard sample (Bottom)'
                        disp('bottom');
                        swan.(sites{i}).(vars{j}).Depth_Chx(k) = {'0.5'};
                        
                    case 'Standard sample (Surface)'
                        disp('surface');
                        swan.(sites{i}).(vars{j}).Depth_Chx(k) = {'0.5'};
                    otherwise
                        if strcmpi(proj,'CSMWQ') == 1
                            swan.(sites{i}).(vars{j}).Depth_Chx(k) = {''};
                        end
                            
                end
            end
            
            
            fprintf(fid,'%s,%s,%6.6f,%s\n',datestr(swan.(sites{i}).(vars{j}).Date(k),'dd-mm-yyyy HH:MM:SS'),...
                swan.(sites{i}).(vars{j}).Depth_Chx{k},swan.(sites{i}).(vars{j}).Data(k),swan.(sites{i}).(vars{j}).QC{k});
        end
        
%         for k = 1:length(swan.(sites{i}).(vars{j}).Date)
%             fprintf(fid,'%s,%4.4f,%6.6f,%s\n',datestr(swan.(sites{i}).(vars{j}).Date(k),'dd-mm-yyyy HH:MM:SS'),...
%                 swan.(sites{i}).(vars{j}).Depth(k),swan.(sites{i}).(vars{j}).Data(k),swan.(sites{i}).(vars{j}).QC{k});
%         end
        fclose(fid);
        
        
        
        headerfile = regexprep(filename,'_DATA','_HEADER');
        
        fid = fopen(headerfile,'wt');
        fprintf(fid,'Agency Name,Department of Water and Environmental Regulation\n');
        fprintf(fid,'Agency Code,DWER\n');
        fprintf(fid,'Program,Estuary\n');
        fprintf(fid,'Project,%s\n',proj);
        thetag = ['DWER-',upper(proj)];
        fprintf(fid,'Tag,%s\n',thetag);
        fprintf(fid,'Data File Name,%s\n',regexprep(filename,outdir,''));
        fprintf(fid,'Location,%s\n',['data-warehouse/csv/dwer/',lower(proj)]);
        
        if max(swan.(sites{i}).(vars{j}).Date) >= datenum(2020,01,01)
            fprintf(fid,'Station Status,Active\n',outputdir);
        else
            fprintf(fid,'Station Status,Inactive\n',outputdir);
        end
        fprintf(fid,'Lat,%6.9f\n',swan.(sites{i}).(vars{j}).Lat);
        fprintf(fid,'Long,%6.9f\n',swan.(sites{i}).(vars{j}).Lon);
        fprintf(fid,'Time Zone,GMT +8\n');
        fprintf(fid,'Vertical Datum,mAHD\n');
        fprintf(fid,'National Station ID,%s\n',regexprep(sites{i},'s',''));
        fprintf(fid,'Site Description,%s\n',regexprep(sites{i},'s',''));
        fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
        fprintf(fid,'Contact Email,wir@water.wa.gov.au\n');
        fprintf(fid,'Variable ID,%s\n',ID);
        switch var_full
            
            case 'Max Discharge'
                fprintf(fid,'Data Classification,HYDRO Flow\n');
            case 'Mean Discharge'
                fprintf(fid,'Data Classification,HYDRO Flow\n');
            case 'Min Discharge'
                fprintf(fid,'Data Classification,HYDRO Flow\n');
            case 'Discharge'
                fprintf(fid,'Data Classification,HYDRO Flow\n');
            case 'Max Stage Height CTF'
                fprintf(fid,'Data Classification,HYDRO Level\n');
            case 'Mean Stage Height CTF'
                fprintf(fid,'Data Classification,HYDRO Level\n');
            case 'Min Stage Height CTF'
                fprintf(fid,'Data Classification,HYDRO Level\n');
            case 'Max Stage Height'
                fprintf(fid,'Data Classification,HYDRO Level\n');
            case 'Mean Stage Height'
                fprintf(fid,'Data Classification,HYDRO Level\n');
            case 'Min Stage Height'
                fprintf(fid,'Data Classification,HYDRO Level\n');
            otherwise
                fprintf(fid,'Data Classification,WQ Grab\n');
        end

            


        SD = mean(diff(swan.(sites{i}).(vars{j}).Date));
        
        fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
        
        fprintf(fid,'Date,dd-mm-yyyy HH:MM:SS\n');
        fprintf(fid,'Depth,Decimal\n');
            
            thevar = [varName{sss},' (',varUnit{sss},')'];
            
            fprintf(fid,'Variable,%s\n',thevar);
            fprintf(fid,'QC,String\n');
            
        fclose(fid);
        
        plot_datafile(filename,plotdir);
    end
end
        
        
 toc       
        
   
        