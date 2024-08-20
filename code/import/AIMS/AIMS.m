function AIMS()
    run ../../actions/csiem_data_paths

    load ../../actions/varkey.mat;
    load ../../actions/agency.mat;
    
    load ../../actions/sitekey.mat;
   

    VarListStruct = agency.AIMS;
    SiteListStruct = sitekey.AIMS;

    % Initialiseing Site struct so "Checkfirst has something to check first" this is the id of first line
    SiteStruct = SiteListStruct.aims_2678;

    % indir = [datapath,'data-lake/AIMS/temp-logger-data/SPLIT/'];
    indir = [datapath,'data-lake/AIMS/temp-logger-data/SPLIT/'];
    
    outdir = [datapath,'data-warehouse/csv/aims/'];
    if ~exist(outdir)
        %%% I want to create each file and header then append each data entry, which means a clean slate each time
        mkdir(outdir);

    else 
        rmdir(outdir,'s');
        mkdir(outdir);
    end

    Var = varkey.(VarListStruct.var1.ID);
    feilds = fields(SiteListStruct);
        for i = 1:length(feilds)
            [fDATA,fHEADER] =  filenamecreator(outdir,SiteListStruct.(feilds{i}),Var);
            FID =  fopen(fDATA,'w');
           fprintf(FID,"Date,Depth,Data,QC\n");
           fclose(FID);

           FID =  fopen(fHEADER,'w');
           % Header info
           depth = 0;
           headerfill(FID,fHEADER,indir,SiteListStruct.(feilds{i}),Var,depth,VarListStruct.var1.ID)
           fclose(FID);
        end



    filelist = {dir(indir).name};

    % first 2 elements are ./ and ../
    % fprintf("STILL ONLY USING 1 of the files\n")
    for filenamecell = filelist(3:end)
        filename = [indir filenamecell{1}]
        % tic
        T = readtable(filename);
        % toc
        
        for i = 1:height(T)
            % This can be safely commented out ebcause I checked using the C code which is faster

            % if strcmp(T{i,9}{1},VarListStruct.var1.Old) ~= 1
            %     disp(T{i,9},' I thought there was only one variable:(\n');
            %     stop;
            % end
            
            Sitestruct = SearchSitelistbyID(SiteListStruct,T{i,5},SiteStruct);

            depth = T{i,8};

            time = T{i,17}{1};
            time(20) = ':';
            val = T{i,18};

            [fDATA,fHEADER] = filenamecreator(outdir,Sitestruct,Var);
            FID = fopen(fDATA,'a');
            fprintf(FID,'%s,%4.4f,%4.4f,%s\n',time,depth,val,'N');
            fclose(FID);
            break;




        end
        break;
    end
end



function headerfill(fid,filename,indir,SubSiteStruct,Varstruct,depth,varid)
    fprintf(fid,'Agency Name,AIMS\n');
    
    fprintf(fid,'Agency Code,AIMS\n');
    fprintf(fid,'Program,Temp\n');
    fprintf(fid,'Project,TempLogger\n');
    fprintf(fid,'Tag,\n');

    %%
    fprintf(fid,'Data File Name,%s\n',filename);
    fprintf(fid,'Location,%s\n',indir);
    %%
    
    fprintf(fid,'Station Status,\n');
    lat = SubSiteStruct.Lat;
    lon = SubSiteStruct.Lon;
    fprintf(fid,'Lat,%6.9f\n',SubSiteStruct.Lat);
    fprintf(fid,'Long,%6.9f\n',SubSiteStruct.Lon);
    fprintf(fid,'Time Zone,GMT +8\n');
    fprintf(fid,'Vertical Datum,mAHD\n');
    fprintf(fid,'National Station ID,%s\n',SubSiteStruct.AED);

    %%
    fprintf(fid,'Site Description,%s\n',SubSiteStruct.Description);
    fprintf(fid,'Deployment,%s\n','Floating');         
    fprintf(fid,'Deployment Position,%s\n','');% '0.0m above Seabed');
    fprintf(fid,'Vertical Reference,%s\n','m below surface');
    fprintf(fid,'Site Mean Depth,%4.4f\n',depth);
    %%

    fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
    fprintf(fid,'Contact Email,%s\n','Lachy Gill, uwa email:00114282@uwa.edu.au 15/07/2024');

    %%
    fprintf(fid,'Variable ID,%s\n',varid);
    %%
    
    fprintf(fid,'Data Category,%s\n',Varstruct.Category);
    
    fprintf(fid,'Sampling Rate (min),%4.4f\n',30);
    
    fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
    fprintf(fid,'Depth,Decimal\n');
    
    
    fprintf(fid,'Variable,%s\n',Varstruct.Name);
    fprintf(fid,'QC,String\n');
end


function SiteStruct = SearchSitelistbyLatLong(SiteListStruct,fileLat,fileLon)
    neverFound = true;
    SitelistFeilds = fields(SiteListStruct);
    NumOfVariables = length(SitelistFeilds);
    fileSiteLatLonPair = [fileLat fileLon];
    %disp(fileSiteLatLonPair)

    for StructSiteIndex = 1:NumOfVariables
        StructSiteLatLonPair = [SiteListStruct.(SitelistFeilds{StructSiteIndex}).Lat ...
                                SiteListStruct.(SitelistFeilds{StructSiteIndex}).Lon];
                                
        %disp(StructSiteLatLonPair)                 
        if fileSiteLatLonPair == StructSiteLatLonPair
            SiteStruct = SiteListStruct.(SitelistFeilds{StructSiteIndex});
            neverFound = false;
            break
        end

    end
    if neverFound == true
        disp(fileSiteLatLonPair)
        disp('Onto sites now')
        for StructSiteIndex = 1:NumOfVariables
            disp(SiteListStruct.(SitelistFeilds{StructSiteIndex}).ID)
            disp([SiteListStruct.(SitelistFeilds{StructSiteIndex}).Lat ...
                                SiteListStruct.(SitelistFeilds{StructSiteIndex}).Lon]);
                                
        end
        stop
        %not a keyword, intentially stop the code because issue has happend
    end
end

function SiteStruct = SearchSitelistbyID(SiteListStruct,filesiteid,CheckfirstStruct)
    neverFound = true;
    SitelistFeilds = fields(SiteListStruct);
    NumOfVariables = length(SitelistFeilds);
    %disp(fileSiteLatLonPair)

    % Check first bit
    if filesiteid == CheckfirstStruct.ID
        SiteStruct = CheckfirstStruct;
        return;
    end


    for StructSiteIndex = 1:NumOfVariables
        StructID = SiteListStruct.(SitelistFeilds{StructSiteIndex}).ID;
                                
        %disp(StructSiteLatLonPair)                 
        if filesiteid == StructID
            SiteStruct = SiteListStruct.(SitelistFeilds{StructSiteIndex});
            neverFound = false;
            break
        end

    end
    if neverFound == true
        disp(filesiteid)
        disp('Onto sites now')
        for StructSiteIndex = 1:NumOfVariables
            disp(SiteListStruct.(SitelistFeilds{StructSiteIndex}).ID)               
        end
        stop
        %not a keyword, intentially stop the code because issue has happend
    end
end

function [data,header] = filenamecreator(outpath,SiteStruct,VarStruct)
    filevar = regexprep(VarStruct.Name,' ','_');
    filesite = SiteStruct.AED;

    base = [outpath,filesite,'_',filevar];
    data = [base,'_DATA.csv'];
    header = [base,'_HEADER.csv'];

end

