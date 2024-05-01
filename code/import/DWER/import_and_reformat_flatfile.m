function  import_and_reformat_flatfile%  clear all; close all;
indir = 'D:\csiem/data-warehouse/csv_holding/dwer/swanest/';


opts = detectImportOptions([indir,'WIR_FLATFILE_ALL_DATA.csv']);
opts = setvartype(opts, 'Depth', 'string');

data = readtable([indir,'WIR_FLATFILE_ALL_DATA.csv'],opts);
data.Depth = fillmissing(data.Depth,'constant'," ");
addpath(genpath('../../functions'));


% Fix any Incorrectly attrib Profiles to Integrated...

Index = find(contains(data.Depth,'-'));
Index_Profile = find(contains(data.Deployment(Index),'Profile'));

data.Deployment(Index(Index_Profile)) = {'Integrated'};
data.DeploymentPosition(Index(Index_Profile)) = {'Depth Range'};

sites = unique(data.Site);

types = unique(data.Deployment);
pos = unique(data.DeploymentPosition);
vert = unique(data.VerticalRef);

vars = unique(data.VarID);


outputdir = 'D:/csiem/data-warehouse/csv/dwer/';






for i = 1:length(sites)
    for j = 1:length(types)
        for k = 1:length(vars)
            
            sss = find(strcmpi(data.Site,sites{i}) == 1 & ...
                strcmpi(data.Deployment,types{j}) == 1 & ...
                strcmpi(data.VarID,vars{k}) == 1);
            
            if ~isempty(sss)
                
                uproj = unique(data.ProgramCode(sss));
                
                outdir = [outputdir,lower(uproj{1}),'/'];
                if ~exist(outdir,'dir')
                    mkdir(outdir);
                end
                
                uvar = unique(data.Varname(sss));
                udep = unique(data.Deployment(sss));
                usite = unique(data.Site(sss));
                uLat = unique(data.Lat(sss));
                uVarID = unique(data.VarID(sss));
                uVarFull = unique(data.VarFull(sss));
                uVarCat = unique(data.DataCategory(sss));
                filename = [outdir,usite{1},'_',regexprep(uvar{1},' ','_'),'_',udep{1},'_DATA.csv'];
                    
                upos = unique(data.DeploymentPosition(sss));
                 uvert = unique(data.VerticalRef(sss));
               
                mdates = datenum(data.Date(sss),'dd-mm-yyyy HH:MM:SS');
                pdates = data.Date(sss);
                pdepth = data.Depth(sss);
                pdata = data.Data(sss);
                
                %Index = find(contains(data.Depth(sss),'-'));
                
                fid = fopen(filename,'wt');
                disp(lower(uvert{1}))
                switch lower(uvert{1})
                
                    case 'm from datum'
                        fprintf(fid,'Date,Height,Data,QC\n');
                    case 'm from surface'
                        fprintf(fid,'Date,Height,Data,QC\n');
                    case 'm above seabed'
                        disp('hi');
                        fprintf(fid,'Date,Height,Data,QC\n');
                    otherwise
                        fprintf(fid,'Date,Depth,Data,QC\n');
                end
                for m = 1:length(pdates)
                    fprintf(fid,'%s,%s,%6.6f,N\n',datestr(mdates(m),'yyyy-mm-dd HH:MM:SS'),pdepth{m},pdata(m));
                end
                fclose(fid);
                
                headerfile = regexprep(filename,'_DATA','_HEADER');
                
                fid = fopen(headerfile,'wt');
                fprintf(fid,'Agency Name,Department of Water and Environmental Regulation\n');
                fprintf(fid,'Agency Code,DWER\n');
                fprintf(fid,'Program,Estuary\n');
                fprintf(fid,'Project,%s\n',uproj{1});
                thetag = ['DWER-',upper(uproj{1})];
                fprintf(fid,'Tag,%s\n',thetag);
                fprintf(fid,'Data File Name,%s\n',regexprep(filename,outdir,''));
                fprintf(fid,'Location,%s\n',['data-warehouse/csv/dwer/',lower(uproj{1})]);
                
                if max(mdates) >= datenum(2020,01,01)
                    fprintf(fid,'Station Status,Active\n',outdir);
                else
                    fprintf(fid,'Station Status,Inactive\n',outdir);
                end
                fprintf(fid,'Lat,%6.9f\n',unique(data.Lat(sss)));
                fprintf(fid,'Long,%6.9f\n',unique(data.Lon(sss)));
                fprintf(fid,'Time Zone,GMT +8\n');
                fprintf(fid,'Vertical Datum,mAHD\n');
                fprintf(fid,'National Station ID,%s\n',regexprep(usite{1},'s',''));
                fprintf(fid,'Site Description,%s\n',regexprep(usite{1},'s',''));
                
                fprintf(fid,'Deployment,%s\n',udep{1});
                fprintf(fid,'Deployment Position,%s\n',upos{1});
                fprintf(fid,'Vertical Reference,%s\n',uvert{1});
                fprintf(fid,'Site Mean Depth,%s\n',[]);

                fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                fprintf(fid,'Contact Email,wir@water.wa.gov.au\n');
                fprintf(fid,'Variable ID,%s\n',uVarID{1});
                fprintf(fid,'Data Category,%s\n',uVarCat{1});
                
                fprintf(fid,'Sampling Rate (min), \n');
                
                fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                fprintf(fid,'Depth,Decimal\n');
                
                thevar = uVarFull{1};
                
                fprintf(fid,'Variable,%s\n',thevar);
                fprintf(fid,'QC,String\n');
                
                fclose(fid);
                
                %plot_datafile(filename);
                
                
                
                
                
            end
        end
    end
    
end
