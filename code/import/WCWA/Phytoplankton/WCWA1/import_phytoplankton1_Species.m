function import_phytoplankton1_Species()

    run('../../../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-lake/WCWA/Phyto/WCWA1/'];
    outdir = [datapath,'data-warehouse/csv/wcwa/PhytoPlankton1/Species/'];



    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../../../actions/varkey.mat;
    load ../../../../actions/agency.mat;
    load ../../../../actions/sitekey.mat;
  

    VarListStruct = agency.WCWA1_PhytoplanktonSpecies;
    SiteListStruct = sitekey.wc;
    % Pre existing sitekey

    filecell = RecursiveListDataFilesInDir(main_dir);
    for SiteNum = 1:length(filecell)
        filename = filecell{SiteNum};
        opts = detectImportOptions(filename,Sheet='Sheet1');
        T = readtable(filename,opts);
        colHeadings = T.Properties.VariableDescriptions;
        for row = 1:height(T)

            StationCode = T.("Site"); % %col 3
            SiteStruct = SearchSitelistbyStr(SiteListStruct,StationCode(row));
      
            Timestr =       T.("Date")(row); % col 1
            DateTimeObj = datetime(Timestr,'InputFormat','dd-MMM-yy');
            DateTimeObj.Format='yyyy-MM-dd HH:mm:ss';
            DateStr = string(DateTimeObj);
            Depth = 0;
            % interval = mean(diff(Timestr));
            % %stores the average time between samples 
            % mininterval = minutes(interval);
            % % convert "duration" type to double
    
            varname =  T.("Taxon")(row); % col 5
            [AgencyStruct,neverFound] = SearchVarlist(VarListStruct,varname);
            if neverFound
                disp(['Species was not found: ' varname])
                continue
            end

            VarStruct = varkey.(AgencyStruct.ID);
            DataVal = T{row,6}*AgencyStruct.Conv; % "Abundance"
            
            % open and write to data file
            [fDATA,fHEADER] = filenamecreator(outdir,SiteStruct,VarStruct);


            if ~exist(fDATA,'file')
                %only gets in here when file doesnt exist already
                fid = fopen(fDATA,'W');
                    fprintf(fid,"Date,Depth,Data,QC\n");
                fclose(fid);

                temp = split(fDATA,filesep);
                filename_short = temp{end};
                fid = fopen(fHEADER,'w');
                    fprintf(fid,'Agency Name,Water Corporation WA\n');
                    
                    fprintf(fid,'Agency Code,WCWA\n');
                    fprintf(fid,'Program,WCWA Phytoplankton\n');
                    fprintf(fid,'Project,WCWA Phytoplankton\n');
                    fprintf(fid,'Tag,WCWA_Phytoplankton_Species\n');

                    %%
                    fprintf(fid,'Data File Name,%s\n',filename_short);
                    fprintf(fid,'Location,%s\n',fullfile(temp{1:end-1}));
                    %%
                    
                    fprintf(fid,'Station Status,\n');
                    fprintf(fid,'Lat,%6.9f\n',SiteStruct.Lat);
                    fprintf(fid,'Long,%6.9f\n',SiteStruct.Lon);
                    fprintf(fid,'Time Zone,GMT +8\n');
                    fprintf(fid,'Vertical Datum,mAHD\n');
                    fprintf(fid,'National Station ID,%s\n',SiteStruct.AED);

                    %%
                    fprintf(fid,'Site Description,%s\n',SiteStruct.Description);
                    fprintf(fid,'Deployment,%s\n','Integrated');
                    fprintf(fid,'Deployment Position,%s\n','');% '0.0m above Seabed' 0m below surface);
                    fprintf(fid,'Vertical Reference,%s\n','');%  'm above Seabed'm below surface);
                    fprintf(fid,'Site Mean Depth,%4.4f\n',0);
                    %%

                    fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                    fprintf(fid,'Contact Email,%s\n','Lachy Gill, uwa email:00114282@uwa.edu.au 12/08/2024');

                    %%
                    fprintf(fid,'Variable ID,%s\n',AgencyStruct.ID);
                    %%
                    
                    fprintf(fid,'Data Category,%s\n',VarStruct.Category);

                    fprintf(fid,'Sampling Rate (min),%4.4f\n',-1);                    
                    fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                    fprintf(fid,'Depth,Decimal\n');
                    
                    
                    fprintf(fid,'Variable,%s\n',VarStruct.Name);
                    fprintf(fid,'QC,String\n');
                fclose(fid);
            end

            fid = fopen(fDATA,'a');
            for i = 1:length(DateStr)
                    fprintf(fid,"%s,%f,%f,N\n",DateStr(i),Depth(i),DataVal(i));
            end
            fclose(fid);

            
        end
    end
      
        % break;
        % This break is so that I only do one site
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
        disp("didnt find site")
        disp(fileSiteStr)
        SiteStruct = 0;
    end
end

function [VarStruct,neverFound] = SearchVarlist(VarListStruct,FileVarHeader)
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
        disp(FileVarHeader)
        VarStruct = 0;
        % for StructVarIndex = 1:NumOfVariables
        %     disp(VarListStruct.(VarlistFeilds{StructVarIndex}).Old)
        % end
        % stop
        %not a keyword, intentially stop the code because issue has happend
    end

end

function filenameCell = RecursiveListDataFilesInDir(folderpath)
    folderpath = [folderpath,'**/*.xlsx'];
    Root = dir(folderpath);
    for i =1:length(Root)
        filenameCell{i} = fullfile(Root(i).folder,Root(i).name);
    end
end


function [data,header] = filenamecreator(outpath,SiteStruct,VarStruct)
    filevar = regexprep(VarStruct.Name,' ','_');
    filevar = regexprep(filevar,'/','.');
    filesite = SiteStruct.AED;

    base = [outpath,filesite,'_',filevar];
    data = [base,'_DATA.csv'];
    header = [base,'_HEADER.csv'];

end