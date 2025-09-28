 function import_csmooring
    addpath(genpath('../../functions/'));
    run('../../actions/csiem_data_paths.m')

    filepath = [datapath,'data-lake/DWER/CSMOORING/csmooring/Cockburn Sound Mooring data/Cockburn Sound Buoy Data/'];

    filelist = dir(fullfile(filepath, '**/*.csv'));  %get list of files and folders in any subfolder
    %                                    / instead of \
    filelist = filelist(~[filelist.isdir]);  %remove folders from list


    load ../../actions/agency.mat;
    load ../../actions/sitekey.mat;
    load ../../actions/varkey.mat;

    sitelist = fieldnames(sitekey.dwermooring);
    varlist = fieldnames(agency.dwer);

    outpath = [datapath,'data-warehouse/csv/dwer/csmooring/']; mkdir(outpath);

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
        %[~,headers] = xlsread(filename,'A3:Z3');
        %tab = readtable(filename)

        tab = readtable(filename,'NumHeaderLines',2,VariableNamingRule='preserve');
        %tab = readtable(filename,'NumHeaderLines',2);
        tabvars = fieldnames(tab);

        %headers = tab.Properties.VariableDescriptions;
        headers = tab.Properties.VariableNames;
        
        
        kk = strfind(filelist(i).name,'Par');
        if isempty(kk)
            if strcmpi(filelist(i).name,'6147036_Water Quality.csv') == 0
                mdate = datenum(tab.Date(1:end),'HH:MM:SS dd/mm/yyyy'); 
                %no longer var1, have actual names now it also now starts at 1 because i told it how big header was
            else
                mdate = datenum(tab.Date(1:end));%,'dd/mm/yyyy HH:MM');
            end
        else
            mdate = datenum(tab.Date(1:end));%,'dd/mm/yyyy HH:MM');
        end
        %sss = find(strcmpi(headers,'Sample Depth (m)') ==1 );
        sss = find(strcmpi(headers,'Sample Depth (m)') ==1 );

        depth = [];

        if ~isempty(sss)

            %theheader = ['Var',num2str(sss)];
            theheader = 'Sample Depth (m)';

            depth = tab.(theheader)(1:end) * 1; 
            depthdata.(['s',num2str(thesite)]).Depth = depth;
            depthdata.(['s',num2str(thesite)]).Mdate = mdate;
            
            Index = find(contains(filelist(i).name,'Profile'));
            
            if ~isempty(Index)
                dep = 'Profile';
                pos = '0.0m below Surface';
                ref = 'm below Surface';
                SMD = [];
            else
                dep = 'Floating';
                pos = '0.0m below Surface';
                ref = 'm below Surface';
                SMD = [];
            end
            
        else
            sss = length(headers) + 2;

            if i == 8
                dval = 0.5;
                depth(1:length(mdate),1) = dval; % Hack for bottom sensor.
                
                dep = 'Fixed';
                pos = '0.5m above Seabed';
                ref = 'm above Seabed';
                SMD = [];
                
            else
                XVals =  depthdata.(['s',num2str(thesite)]).Mdate;
                YVals =  depthdata.(['s',num2str(thesite)]).Depth;
                xQVals = mdate;

                if foundsite == 7
                    XVals = XVals(2:end);
                    YVals = YVals(2:end);
                    xQVals = xQVals(2:end);
                end

                

                %depth = interp1(depthdata.(['s',num2str(thesite)]).Mdate,depthdata.(['s',num2str(thesite)]).Depth,mdate);
                depth = interp1(XVals,YVals,xQVals);
                if foundsite ==7
                    depth = [NaN;depth]

                
                if i == 9
                        dep = 'Fixed';
                        pos = '0.5m below Surface';
                        ref = 'm below Surface';
                        SMD = [];
                        
                        dval = 0.5;
                        depth(1:length(mdate),1) = dval; % Hack for bottom sensor.
                        
                end
            end

        
            
        end

        for j = 2:2:sss-2
            thevar = headers{j};
            thevar = regexprep(thevar,char(65533),'');
            disp(['Var found: ', thevar]);
            
            %thedata = tab.(['Var',num2str(j)])(5:end);
            %theQC = tab.(['Var',num2str(j+1)])(5:end);

            thedata = tab{:,j};
            if iscell(thedata)
                thedata  = str2double(thedata);
            end

            theQC = tab{:,j+1};

            if ~isnumeric(theQC(1))
                theQC = [];
                theQC(1:length(thedata),1) = NaN;
            end


            foundvar = 0;
            for k = 1:length(varlist)
                if strcmpi(agency.dwer.(varlist{k}).Old,thevar)== 1
                    foundvar = k;
                end
            end
            if foundvar == 0;
                format compact
                thevar
                thevarUnicode = double(thevar)
                for k = 1:length(varlist)
                    agency.dwer.(varlist{k}).Old
                    double(agency.dwer.(varlist{k}).Old)
                end


                stop; 
            end

            varID = agency.dwer.(varlist{foundvar}).ID;

            if and(foundvar == 20,foundsite == 3 | foundsite == 4| foundsite == 7 |foundsite == 8) ==  1
                disp('Skipping empty Column')
                continue

            end

            % SG add this
            if ismember(foundvar, 52:60)
                disp(['Skipping variable index ', num2str(foundvar)])
                continue
            end

            if and(foundvar  == 3,foundsite == 7) ==  1
                disp('Skipping empty Column')
                continue

            end

            foundsite;
            foundvar;
            thedata = thedata .* agency.dwer.(varlist{foundvar}).Conv;

            
            if strcmpi(varID,'var00323') == 1 & i ~= 9
                    varID = 'var00322';
                    disp('switching to bottom par');
            end


            

            [X,Y] = ll2utm   (sitekey.dwermooring.(sitelist{foundsite}).Lat,sitekey.dwermooring.(sitelist{foundsite}).Lon,-50);

            filevar = regexprep(varkey.(varID).Name,' ','_');

            filename = [outpath,sitekey.dwermooring.(sitelist{foundsite}).AED,'_',filevar,'_DATA.csv'];
            
            if i == 8
                filename = regexprep(filename,'_DATA.csv','_Bottom_DATA.csv');
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

            headerfile = regexprep(filename,'_DATA.csv','_HEADER.csv');
            headerfile
            fid = fopen(headerfile,'wt');
            fprintf(fid,'Agency Name,Department of Water and Environmental Regulation\n');
            fprintf(fid,'Agency Code,DWER\n');
            fprintf(fid,'Program,CSMOORING\n');
            fprintf(fid,'Project,csmooring\n');
            fprintf(fid,'Tag,DWER-CS-MOORING\n');
            fprintf(fid,'Data File Name,%s\n',replace(filename,outpath,''));
            fprintf(fid,'Location,%s\n',outpath);


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
            fprintf(fid,'Variable ID,%s\n',agency.dwer.(varlist{foundvar}).ID);

            fprintf(fid,'Data Category,%s\n',varkey.(varID).Category);


            SD = mean(diff(mdate));

            fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * (60*24));

            fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
            fprintf(fid,'Depth,Decimal\n');

            thevar = [varkey.(varID).Name,' (',varkey.(varID).Unit,')'];

            fprintf(fid,'Variable,%s\n',thevar);
            fprintf(fid,'QC,String\n');

            fclose(fid);

            %plot_datafile(filename);




        end









    end
end


