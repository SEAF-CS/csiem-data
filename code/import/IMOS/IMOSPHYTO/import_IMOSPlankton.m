function import_IMOSPlankton()

    run('../../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-lake/IMOS/REF/phyto/species/'];
    outdir = [datapath,'data-warehouse/csv/imos/ref/phy/species/'];



    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../../actions/varkey.mat;
    load ../../../actions/agency.mat;
    load ../../../actions/sitekey.mat;
  

    VarListStruct = agency.IMOS_Phytoplankton;
    SiteListStruct = sitekey.IMOS_Phytoplankton;

    brokenNamesFID = fopen("UnimportedNames.txt",'w');

    filecell = RecursiveListDataFilesInDir(main_dir);
    for SiteNum = 1:length(filecell)
        filename = filecell{SiteNum};
        if contains(filename, '._')
            % Skip this file if it starts with dot underline.
            continue;
        end
        opts = detectImportOptions(filename);
        T = readtable(filename,opts);
        colHeadings = T.Properties.VariableDescriptions;
            StationCode = T.("StationCode"); % %col 3
            %% from checking the ~140 entries all at same site so find first site then check they have the same stationcode
            DoubleCheck = ~strcmp(StationCode{1},StationCode); % This should give all Zeros
            SHOULDBEZERO = sum(DoubleCheck)

            
            SiteStruct = SearchSitelistbyStr(SiteListStruct,StationCode{1});
            % Lat =           T.("Latitude"); % %col 4
            % Lon =           T.("Longitude"); % %col 5
            %All the same so dont need indiviudal ones

            Timestr =       T.("SampleTime_Local"); % col 8
            interval = mean(diff(Timestr));
            %stores the average time between samples 
            mininterval = minutes(interval);
            % convert "duration" type to double
            Depth =         T.("SampleDepth_m"); % col 13

            NumOfVars = width(T)-13 % 14 is the first variable col
            for varnum = 1:NumOfVars
                colIndex = varnum+13;
                %Skip method ie col 17
                if colIndex == 17
                    continue
                end

                varname = colHeadings{colIndex};
                [AgencyStruct,neverFound] = SearchVarlist(VarListStruct,varname,brokenNamesFID);
                if neverFound
                    continue
                end
                

                VarStruct = varkey.(AgencyStruct.ID);
                DataVal = T{:,colIndex}*AgencyStruct.Conv;
                
                % open and write to data file
                [fDATA,fHEADER] = filenamecreator(outdir,SiteStruct,VarStruct);

                fid = fopen(fDATA,'W');
                fprintf(fid,"Date,Depth,Data,QC\n");
                for i = 1:length(Timestr)
                        fprintf(fid,"%s,%f,%f,N\n",Timestr(i),Depth(i),DataVal(i));
                end
                fclose(fid);


                fid = fopen(fHEADER,'w');
                    fprintf(fid,'Agency Name,Integrated Marine Observing System\n');
                    
                    fprintf(fid,'Agency Code,IMOS\n');
                    fprintf(fid,'Program,REF\n');
                    fprintf(fid,'Project,phyto\n');
                    fprintf(fid,'Tag,IMOS-REF-PHY\n');

                    %%
                    fprintf(fid,'Data File Name,%s\n',fDATA);
                    fprintf(fid,'Location,N/A\n');
                    %%
                    
                    fprintf(fid,'Station Status,\n');
                    fprintf(fid,'Lat,%6.9f\n',SiteStruct.Lat);
                    fprintf(fid,'Long,%6.9f\n',SiteStruct.Lon);
                    fprintf(fid,'Time Zone,GMT +8\n');
                    fprintf(fid,'Vertical Datum,mAHD\n');
                    fprintf(fid,'National Station ID,%s\n',SiteStruct.AED);

                    %%
                    fprintf(fid,'Site Description,%s\n',SiteStruct.Description);
                    fprintf(fid,'Deployment,%s\n','Floating');
                    fprintf(fid,'Deployment Position,%s\n','0.0m below Surface');
                    fprintf(fid,'Vertical Reference,%s\n','m below Surface');
                    fprintf(fid,'Site Mean Depth,%4.4f\n',mean(Depth));
                    %%

                    fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                    fprintf(fid,'Contact Email,%s\n','Lachy Gill <00114282@uwa.edu.au> 05/08/2024');

                    %%
                    fprintf(fid,'Variable ID,%s\n',AgencyStruct.ID);
                    %%
                    
                    fprintf(fid,'Data Category,%s\n',VarStruct.Category);

                    fprintf(fid,'Sampling Rate (min),%4.4f\n',mininterval);                    
                    fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                    fprintf(fid,'Depth,Decimal\n');
                    
                    
                    fprintf(fid,'Variable,%s\n',VarStruct.Name);
                    fprintf(fid,'QC,String\n');
            fclose(fid);
            
            
            end
        % break;
        % This break is so that I only do one site
    end
    fclose(brokenNamesFID);
end


function SiteStruct = SearchSitelistbyStr(SiteListStruct,fileSiteStr)
    neverFound = true;
    SitelistFeilds = fields(SiteListStruct);
    NumOfVariables = length(SitelistFeilds);

    for StructSiteIndex = 1:NumOfVariables
        StructSiteStr = SiteListStruct.(SitelistFeilds{StructSiteIndex}).ID;                              
                     
        if strcmp(StructSiteStr,fileSiteStr) == 1
            SiteStruct = SiteListStruct.(SitelistFeilds{StructSiteIndex});
            neverFound = false;
            break
        end

    end
    if neverFound == true
        disp([fileSiteStr "\n"]);
        SiteStruct = 0;
    end
end

function [VarStruct,neverFound] = SearchVarlist(VarListStruct,FileVarHeader,fid)
    neverFound = true;
    VarlistFeilds = fields(VarListStruct);
    NumOfVariables = length(VarlistFeilds);

    for StructVarIndex = 1:NumOfVariables
        StructVarHeader = VarListStruct.(VarlistFeilds{StructVarIndex}).Old;
        % Check if FileVarHeader == StructVarHeader
        if strcmp(FileVarHeader,StructVarHeader)
            VarStruct = VarListStruct.(VarlistFeilds{StructVarIndex});
            neverFound = false;
            break
        end

    end
    if neverFound == true
        fprintf(fid,"%s\n",FileVarHeader);
        % disp(FileVarHeader)
        VarStruct = 0;
        % for StructVarIndex = 1:NumOfVariables
        %     disp(VarListStruct.(VarlistFeilds{StructVarIndex}).Old)
        % end
        % stop
        %not a keyword, intentially stop the code because issue has happend
    end

end

function filenameCell = RecursiveListDataFilesInDir(folderpath)
    folderpath = [folderpath,'**/*.csv'];
    Root = dir(folderpath);
    for i =1:length(Root)
        filenameCell{i} = fullfile(Root(i).folder,Root(i).name);
    end
end


function [data,header] = filenamecreator(outpath,SiteStruct,VarStruct)
    filevar = regexprep(VarStruct.Name,' ','_');
    filevar = regexprep(filevar,'\/','.');
    filesite = SiteStruct.AED;

    base = [outpath,filesite,'_',filevar];
    data = [base,'_DATA.csv'];
    header = [base,'_HEADER.csv'];

end