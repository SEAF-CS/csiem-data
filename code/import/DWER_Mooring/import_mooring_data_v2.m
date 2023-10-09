clear all; close all;
addpath(genpath('../../functions/'));

filepath = 'D:\csiem\data-lake\DWER\csmooring\Cockburn Sound Mooring data\Cockburn Sound Buoy Data\';

filelist = dir(fullfile(filepath, '**\*.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list


load ../../actions/agency.mat;
load ../../actions/sitekey.mat;
load ../../actions/varkey.mat;

sitelist = fieldnames(sitekey.dwermooring);
varlist = fieldnames(agency.dwermooring);

outpath = 'D:\csiem\data-warehouse\csv\dwer\csmooring\';mkdir(outpath);

for i = 1:length(filelist)

    st = split(filelist(i).name,'_');
    thesite = str2num(st{1});

    foundsite = 0;
    for k = 1:length(sitelist)
        if sitekey.dwermooring.(sitelist{k}).ID == thesite
            foundsite = k;
        end
    end
    if foundsite == 0
        stop;
    end




    filename = [filelist(i).folder,'/',filelist(i).name];

    [~,headers] = xlsread(filename,'A3:Z3');

    tab = readtable(filename);

    tabvars = fieldnames(tab);

    
    kk = strfind(filelist(i).name,'Par');
    
    if isempty(kk)
        if strcmpi(filelist(i).name,'6147036_Water Quality.csv') == 0
            mdate = datenum(tab.Var1(5:end),'HH:MM:SS dd/mm/yyyy');
        else
            mdate = datenum(tab.Var1(5:end));%,'dd/mm/yyyy HH:MM');
        end
    else
        mdate = datenum(tab.Var1(5:end));%,'dd/mm/yyyy HH:MM');
    end
    sss = find(strcmpi(headers,'Sample Depth (m)') ==1 );


    depth = [];

    if ~isempty(sss)

        theheader = ['Var',num2str(sss)];

        depth = tab.(theheader)(5:end) * 1;
        depthdata.(['s',num2str(thesite)]).Depth = depth;
        depthdata.(['s',num2str(thesite)]).Mdate = mdate;
        
        Index = find(contains(filelist(i).name,'Profile'));
        
        if ~isempty(Index)
            dep = 'Profile';
            pos = 'm from Surface';
            ref = 'Water Surface';
            SMD = [];
        else
            dep = 'Floating';
            pos = 'm from Surface';
            ref = 'Water Surface';
            SMD = [];
        end
        
    else
        sss = length(headers) + 2;

        if i == 8
            dval = 0.5;
            depth(1:length(mdate),1) = dval; % Hack for bottom sensor.
            
            dep = 'Fixed';
            pos = '0.5m from Seabed';
            ref = 'm from Seabed';
            SMD = [];
            
        else
            depth = interp1(depthdata.(['s',num2str(thesite)]).Mdate,depthdata.(['s',num2str(thesite)]).Depth,mdate);
            
            if i == 9
                    dep = 'Fixed';
                    pos = '0.5m from Surface';
                    ref = 'm from Surface';
                    SMD = [];
                    
                    dval = 0.5;
                    depth(1:length(mdate),1) = dval; % Hack for bottom sensor.
                    
            end
        end

    
        
    end

    for j = 2:2:sss-2
        thevar = headers{j};
        thedata = tab.(['Var',num2str(j)])(5:end);
        theQC = tab.(['Var',num2str(j+1)])(5:end);
        if ~isnumeric(theQC(1))
            theQC = [];
            theQC(1:length(thedata),1) = NaN;
        end


        foundvar = 0;

        for k = 1:length(varlist)
            if strcmpi(agency.dwermooring.(varlist{k}).Old,thevar)== 1
                foundvar = k;
            end
        end
        if foundvar == 0;
            stop;
        end

        varID = agency.dwermooring.(varlist{foundvar}).ID;
        thedata = thedata .* agency.dwermooring.(varlist{foundvar}).Conv;



        [X,Y] = ll2utm   (sitekey.dwermooring.(sitelist{foundsite}).Lat,sitekey.dwermooring.(sitelist{foundsite}).Lon,-50);

        filevar = regexprep(varkey.(varID).Name,' ','_');

        filename = [outpath,sitekey.dwermooring.(sitelist{foundsite}).AED,'_',filevar,'_DATA.csv'];
        
        if i == 8
            filename = regexprep(filename,'_DATA','_Bottom_DATA');
        end
        
        filename
        fid = fopen(filename,'wt');
        if i == 8
            fprintf(fid,'Date,Height,Data,QC\n');
        else
            fprintf(fid,'Date,Depth,Data,QC\n');
        end
        for nn = 1:length(thedata)
            if ~isnan(thedata(nn))
                fprintf(fid,'%s,%4.4f,%4.4f,%i\n',datestr(mdate(nn),'yyyy-mm-dd HH:MM:SS'),depth(nn),thedata(nn),theQC(nn));
            end
        end
        fclose(fid);

        headerfile = regexprep(filename,'_DATA','_HEADER');
        headerfile
        fid = fopen(headerfile,'wt');
        fprintf(fid,'Agency Name,Department of Water and Environmental Regulation\n');
        fprintf(fid,'Agency Code,DWER\n');
        fprintf(fid,'Program,Cockburn Sound Marine Water Quality Monitoring\n');
        fprintf(fid,'Project,CSMOORING\n');
        fprintf(fid,'Tag,DWER-CSMOORING\n');
        fprintf(fid,'Data File Name,%s\n',regexprep(filename,outpath,''));
        fprintf(fid,'Location,%s\n',['data-warehouse/csv/dwer/csmooring_v2']);


        fprintf(fid,'Station Status,Inactive\n');
        fprintf(fid,'Lat,%6.9f\n',sitekey.dwermooring.(sitelist{foundsite}).Lat);
        fprintf(fid,'Long,%6.9f\n',sitekey.dwermooring.(sitelist{foundsite}).Lon);
        fprintf(fid,'Time Zone,GMT +8\n');
        fprintf(fid,'Vertical Datum,mAHD\n');
        fprintf(fid,'National Station ID,%s\n',num2str(sitekey.dwermooring.(sitelist{foundsite}).ID));
        fprintf(fid,'Site Description,%s\n',sitekey.dwermooring.(sitelist{foundsite}).Description);
        fprintf(fid,'Deployment,%s\n',dep);
        fprintf(fid,'Deployment Position,%s\n',pos);
        fprintf(fid,'Vertical Reference,%s\n',ref);
        fprintf(fid,'Site Mean Depth,%s\n',[]);
        fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
        fprintf(fid,'Contact Email,\n');
        fprintf(fid,'Variable ID,%s\n',agency.dwermooring.(varlist{foundvar}).ID);

        fprintf(fid,'Data Classification,WQ Grab\n');


        SD = mean(diff(mdate));

        fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));

        fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
        fprintf(fid,'Depth,Decimal\n');

        thevar = [varkey.(varID).Name,' (',varkey.(varID).Unit,')'];

        fprintf(fid,'Variable,%s\n',thevar);
        fprintf(fid,'QC,String\n');

        fclose(fid);

        plot_datafile(filename);




    end









end


