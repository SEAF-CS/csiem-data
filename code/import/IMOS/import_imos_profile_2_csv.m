function import_imos_profile_2_csv;

addpath(genpath('../../functions/'));

run('../../actions/csiem_data_paths.m')
thefile = [datapath,'data-lake/IMOS/AMNM/amnmprofile/IMOS_-_Australian_National_Mooring_Network_(ANMN)_-_CTD_Profiles_2019_2022.csv'];

load ../../actions/varkey.mat;
load ../../actions/agency.mat;
load ../../actions/sitekey.mat;

outpath = [datapath,'data-warehouse/csv_holding/imos/amnm/amnmprofile/'];

if ~exist(outpath,'dir')
    mkdir(outpath);
end


thesiteval = fieldnames(sitekey.imosamnm);
thevarval = fieldnames(varkey);
theagencyval = fieldnames(agency.IMOS);

Table = readtable(thefile);
headers = Table.Properties.VariableNames;
%[~,headers] = xlsread(thefile,'A1:AO1');

%snum,sstr] = xlsread(thefile,'A2:AO2000');

%stations = sstr(:,3);
stations = Table{:,3};

sdate = Table{:,5};
%sdate = sstr(:,5);
sdate = regexprep(sdate,'T',' ');
sdate = regexprep(sdate,'Z','');


mdates = datenum(sdate,'yyyy-mm-dd HH:MM:SS');


%Depths = snum(:,14);
Depths = Table{:,14};
Depths(isnan(Depths)) = 0;


ustations = unique(stations);

for i = 19:length(headers)
    disp(['Header ' headers{i}])
    for j = 1:length(ustations)
        foundstation = 0 ;
        for k = 1:length(thesiteval)
            if strcmpi(sitekey.imosamnm.(thesiteval{k}).ID,ustations{j}) == 1
                foundstation = k;
                disp(['  Found Site ',sitekey.imosamnm.(thesiteval{k}).ID])
            end
        end
        
        foundvar = 0;
        
        for k = 1:length(theagencyval)
            if strcmpi(agency.IMOS.(theagencyval{k}).Old,headers{i}) == 1
                foundvar = k;
                ID = agency.IMOS.(theagencyval{k}).ID;
                VarStruct = varkey.(ID);
                disp(['     Found Var ',varkey.(ID).Name])
            end
        end
    
        
        if foundvar > 0
            
            sss = find(strcmpi(stations,ustations{j}) == 1);
            
            %thedata_raw = snum(sss,i-1) * agency.IMOS.(theagencyval{foundvar}).Conv;
            thedata_raw = Table{sss,i-1} * agency.IMOS.(theagencyval{foundvar}).Conv;
            ttt = find(~isnan(thedata_raw) == 1);
            thedata = thedata_raw(ttt);
            
            if ~isempty(thedata)
            disp('      Writing file')
            thedepth = Depths(sss(ttt));
            thedate = mdates(sss(ttt));
            thedateString = sdate(sss(ttt));
            QC = 'N';
            
            
            
            
            filevar = regexprep(varkey.(ID).Name,' ','_');
            filevar = regexprep(filevar,'+','_');
            filename = [outpath,sitekey.imosamnm.(thesiteval{foundstation}).AED,'_',filevar,'_2020_DATA.csv'];
            fid = fopen(filename,'W');
            fprintf(fid,'Date,Depth,Data,QC\n');
            for nn = 1:length(thedata)
                fprintf(fid,'%s,%4.4f,%4.4f,%s\n',thedateString{nn},thedepth(nn),thedata(nn),QC);
            end
            fclose(fid);
            
            headerfile = regexprep(filename,'_DATA.csv','_HEADER.csv');
            
            fid = fopen(headerfile,'W');
            fprintf(fid,'Agency Name,Integrated Marine Observing System\n');
            fprintf(fid,'Agency Code,IMOS\n');
            fprintf(fid,'Program,AMNM\n');
            fprintf(fid,'Project,amnmprofile\n');
            fprintf(fid,'Tag,IMOS-ANMN-PROFILE\n');
            fprintf(fid,'Data File Name,%s\n',regexprep(filename,outpath,''));
            fprintf(fid,'Location,%s\n',outpath);
            
            
            fprintf(fid,'Station Status,Inactive\n');
            fprintf(fid,'Lat,%6.9f\n',sitekey.imosamnm.(thesiteval{foundstation}).Lat);
            fprintf(fid,'Long,%6.9f\n',sitekey.imosamnm.(thesiteval{foundstation}).Lon);
            fprintf(fid,'Time Zone,GMT +8\n');
            fprintf(fid,'Vertical Datum,mAHD\n');
            fprintf(fid,'National Station ID,%s\n',[sitekey.imosamnm.(thesiteval{foundstation}).ID,'_PROFILE']);
            fprintf(fid,'Site Description,%s\n',sitekey.imosamnm.(thesiteval{foundstation}).Description);
            fprintf(fid,'Deployment,%s\n','Profile');
            fprintf(fid,'Deployment Position,%s\n','m from Surface');
            fprintf(fid,'Vertical Reference,%s\n','Water Surface');
            fprintf(fid,'Site Mean Depth,%s\n','');

            fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
            fprintf(fid,'Contact Email,\n');
            fprintf(fid,'Variable ID,%s\n',agency.IMOS.(theagencyval{foundvar}).ID);
            
            fprintf(fid,'Data Category,%s\n',varkey.(ID).Category);
            
            
            SD = mean(diff(thedate));
            
            fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));
            
            fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
            fprintf(fid,'Depth,Decimal\n');
            
            thevar = [varkey.(ID).Name,' (',varkey.(ID).Unit,')'];
            
            fprintf(fid,'Variable,%s\n',thevar);
            fprintf(fid,'QC,String\n');
            
            fclose(fid);
            %plot_datafile(filename);

            end
            
        end
    end
    
end





