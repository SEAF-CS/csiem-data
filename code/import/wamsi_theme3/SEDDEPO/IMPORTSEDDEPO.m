function IMPORTSEDDEPO()
    load ../../../actions/varkey.mat;
    load ../../../actions/agency.mat;
     load ../../../actions/sitekey.mat;

    VarListStruct = agency.wwmsp3;
    SiteListStruct = sitekey.WWMSP31SedimentDeposition;

    run('../../../actions/csiem_data_paths.m')
    outdir = [datapath,'data-warehouse/csv/wamsi/wwmsp3/seddep/'];
    mkdir(outdir);


    
    dataDir = [datapath,'data-lake/WAMSI/WWMSP3/WWMSP3.1_SedimentDeposition/Sediment Deposition Logger Data/'];
    % The data is structured into folders of sites: so I want to iterate through each site folder,
    %  but theres a readme, so dont want to iterate over that.
    FolderStructure = dir(dataDir);
    for folderIndex = 3:length(FolderStructure)
        % starts at 3 to skip ./ and ../
        site = FolderStructure(folderIndex);
        if site.isdir == 0
            % Skipping readme
            continue
        end
        sitefolder = fullfile(dataDir,site.name);

        disp(['Site ' site.name]);
    
        AEDID = ['site',site.name];


        SiteStruct = SearchSitelistbyAEDID(SiteListStruct,AEDID);

        fileCell = {dir(sitefolder).name}';
        fileCell = fileCell(3:end); %skips ./ and ../

        for i = 1:length(fileCell);
            display(['   ',fileCell{i}])

            datafilename = fullfile(sitefolder,fileCell{i});
            warning('off','MATLAB:table:ModifiedAndSavedVarnames')
            DataFilesTable = readtable(datafilename,"TreatAsMissing","NA");
            warning('on','MATLAB:table:ModifiedAndSavedVarnames')
            Vars = DataFilesTable.Properties.VariableDescriptions';
    
            % First elemetn is Date;
            DateVec = DataFilesTable{:,1};
            DepthVec = DataFilesTable{:,7};
            % Desired format : "yyyy-mm-dd HH:MM:SS"
            % Who it is read in "13/12/2022 11:40"
            DateString = regexprep(string(DateVec),'/','-');
            
            % Skipping Date col
            for varIndex = 2:length(Vars)

                % displays current varibale name and how big it is (uses date)
                disp(['     Processing Variable ' Vars{varIndex} ' ' num2str(length(DateVec)) 'x1']);
    
                %workout what variable we are dealing with
                AgencyStruct = SearchVarlist(VarListStruct,Vars,varIndex);
    
                if strcmp(AgencyStruct.ID,'var00')
                    disp(['         ',Vars{varIndex}, 'is being skipped']);
                    continue
                end

                VarStruct = varkey.(AgencyStruct.ID);
                [fnameData,fnameHeader] = filenamecreator(outdir,SiteStruct,VarStruct);
    
                        
    
                fid = fopen(fnameData,'W');
                fprintf(fid,'Date,Depth,Data,QC\n');
                DataVec = DataFilesTable{:,varIndex}*AgencyStruct.Conv;
                
    
    
    
                for nn = 1:length(DataVec)
                    if isnan(DataVec(nn))
                        continue
                    end
    
                    QC = 'N';
                    fprintf(fid,'%s,%4.4f,%4.4f,%s\n',DateString(nn),DepthVec(nn),DataVec(nn),QC);
                end
                fclose(fid);
    
                
                lat = SiteStruct.Lat;
                lon = SiteStruct.Lon;
                ID = SiteStruct.ID;
                Desc = SiteStruct.Description;
    
    
                varID = AgencyStruct.ID;
                Cat = VarStruct.Category;
                varstring = VarStruct.Name;
    
                wdate = '';
                sitedepth = '';
                %%bad code practise by copied from
                %csiem-data-hub/git/code/import/wamsi_theme3/SEDPSD/Functions/write_header
                write_header(fnameHeader,lat,lon,ID,Desc,varID,Cat,varstring,wdate,sitedepth)
    
            end
        end
    end
    



end

function VarStruct = SearchVarlist(VarListStruct,FileHeaders,varIndex)
    neverFound = true;
    VarlistFeilds = fields(VarListStruct);
    NumOfVariables = length(VarlistFeilds);

    FileVarHeader = FileHeaders{varIndex};

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
        disp(FileHeaders{varIndex})
        for StructVarIndex = 1:NumOfVariables
            disp(VarListStruct.(VarlistFeilds{StructVarIndex}).Old)
        end
        stop
        %not a keyword, intentially stop the code because issue has happend
    end

end

function SiteStruct = SearchSitelistbyAEDID(SiteListStruct,AEDID)
    neverFound = true;
    SitelistFeilds = fields(SiteListStruct);
    NumOfVariables = length(SitelistFeilds);
   
    for StructSiteIndex = 1:NumOfVariables
                                                 
        if strcmp(AEDID,SiteListStruct.(SitelistFeilds{StructSiteIndex}).AED)
            SiteStruct = SiteListStruct.(SitelistFeilds{StructSiteIndex});
            neverFound = false;
            break
        end

    end
    if neverFound == true
        disp('DataFile site:');
        disp(AEDID)
        disp('Sitekey list:');
        for StructSiteIndex = 1:NumOfVariables
            disp(SiteListStruct.(SitelistFeilds{StructSiteIndex}).AED);                 
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

