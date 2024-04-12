function ImportWRF()
    % load ../../actions/varkey.mat;
    % load ../../actions/agency.mat;
     load ../../actions/sitekey.mat;

    %VarListStruct = agency.wamsiwrf;
    SiteListStruct = sitekey.wwmsp1wrf;

    outdir = '../../../../data-warehouse/csv/wamsi/wwmsp1.1_wrf/';
    mkdir(outdir);


    
    %% Get list of data files
    dataDir = '../../../../data-lake/WAMSI/WWMSP1.1 - WRF/';
    fileCell = {dir(dataDir).name}';
    fileCell = fileCell(3:end) %skips ./ and ../

    for i = 1:length(fileCell);

        disp(['Site ' num2str(i) ' ' fileCell{i}]);
        %WRF_2022_AEID.csv
        AEDID = fileCell{i}(10:end-4);


        SiteStruct = SearchSitelistbyAEDID(SiteListStruct,AEDID);
        % it appears that the date is saved in all three variables, potentially could save read time by not reading in all 3 of the same time vecs

        DataFilesTable = readtable([dataDir,fileCell{i}]);
           
        Vars = DataFilesTable.Properties.VariableNames';
        % First elemetn is Date;
        DateVec = DataFilesTable{:,1};
        for varIndex = 2:length(Vars)
            % displays current varibale name and how big it is (uses date)
            disp(['     Processing Variable ' Vars{varIndex} ' ' num2str(length(DateVec)) 'x1']);

            %workout what variable we are dealing with
            disp('      Havent got variable key done yet')
            %AgencyStruct = SearchVarlist(VarListStruct,Vars,varIndex);
            %VarStruct = varkey.(AgencyStruct.ID);
            %[fnameData,fnameHeader] = filenamecreator(outdir,SiteStruct,VarStruct);

            tempname = [outdir,Vars{varIndex},SiteStruct.AED];
            fnameData = [tempname,'_Data.csv'];
            fnameHeader = [tempname,'_Header.csv'];
            

            fid = fopen(fnameData,'W');
            fprintf(fid,'Date,Depth,Data,QC\n');
            DataVec = DataFilesTable{:,varIndex};
            for nn = 1:length(DataVec)
                DateString = datestr(DateVec(nn),"yyyy-mm-dd HH:MM:SS");
                Depth = 0;
                QC = 'N';
                fprintf(fid,'%s,%4.4f,%4.4f,%s\n',DateString,Depth,DataVec(nn),QC);
            end
            fclose(fid);

            
            lat = SiteStruct.Lat;
            lon = SiteStruct.Lon;
            ID = SiteStruct.ID;
            Desc = SiteStruct.Description;


            disp('      Skipping header stuff DONT FORGET')
            % varID = AgencyStruct.ID;
            % Cat = VarStruct.Category;
            % varstring = VarStruct.Name;

            varID = 0;%AgencyStruct.ID;
            Cat = '';%VarStruct.Category;
            varstring = '';%VarStruct.Name;

            wdate = '';
            sitedepth = '';
            %%bad code practise by copied from
            %csiem-data-hub/git/code/import/wamsi_theme3/SEDPSD/Functions/write_header
            write_header(fnameHeader,lat,lon,ID,Desc,varID,Cat,varstring,wdate,sitedepth)

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
    header = [base,'_Header.csv'];

end