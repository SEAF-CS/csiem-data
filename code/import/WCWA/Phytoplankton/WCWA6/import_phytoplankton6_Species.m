function import_phytoplankton6_Species()

    run('../../../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-lake/WCWA/Phyto/WCWA3/'];
    outdir = [datapath,'data-warehouse2/csv/wcwa/PhytoPlankton6/Species/'];



    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../../../actions/varkey.mat;
    load ../../../../actions/agency.mat;
    load ../../../../actions/sitekey.mat;

    VarListStruct = agency.WCWA6_PhytoplanktonSpecies;
    SiteListStruct = sitekey.WCWA3Phyto;
    varnameInsideAgencyStruct = fieldnames(VarListStruct);

    unimprtedFID = fopen("UnimportedSpecies.txt","w");


    filecell = RecursiveListDataFilesInDir(main_dir);
    for fileNum = 1:length(filecell)
        filename = filecell{fileNum};

        T = ReadinDataFile(filename);


        %% for speed finding all variable id's at the start
        varIds = cell(height(T),1);
        AgencyIndexs = nan(height(T),1);
        for rowNum = 1:height(T)
            % match to varkey
            varname =  T{rowNum,1}; % col 1
            [AgencyStruct,AgencyIndex] = SearchVarlist(VarListStruct,varname);
            if AgencyIndex == 0 
                fprintf(unimprtedFID,"%s\n",varname{1});
                varIds{rowNum} = '0';
                AgencyIndexs(rowNum) = 0;
                %% this is used to skip groups in the species code
                continue
            end
            varIds{rowNum} = AgencyStruct.ID;
            AgencyIndexs(rowNum) = AgencyIndex;
            
        end


        dataindexVec = [4,7];

        NumofSites = length(dataindexVec);
        for SiteNum = 1:NumofSites
            SiteName = ['N' num2str(SiteNum)];
            SiteStruct = SearchSitelistbyStr(SiteListStruct,SiteName);

            dataindex = dataindexVec(SiteNum);
            DateStr = '1999-2-24 00:00:00'; %'feb 24 1999'
            
            for rowNum = 1:height(T)
                % match to varkey
                if AgencyIndexs(rowNum) == 0
                    continue
                    % This is because of group
                end

                varId = varIds{rowNum};
                VarStruct = varkey.(varId);
                Conv = VarListStruct.(varnameInsideAgencyStruct{AgencyIndexs(rowNum)}).Conv; 
                Depth = 0;
                DataVal = T{rowNum,dataindex}*Conv; % "Count"
                if isnan(DataVal)
                    continue    
                end

                [fDATA,fHEADER] = filenamecreator(outdir,SiteStruct,VarStruct);


                if ~exist(fDATA,'file')
                    heightOrdepth = 'Depth';
                    Deployment = 'Integrated';
                    VerticalRef = '';
                    %only gets in here when file doesnt exist already
                    fid = fopen(fDATA,'W');
                    fprintf(fid,"Date,%s,Data,QC\n",heightOrdepth);
                    fclose(fid);

                    temp = split(fDATA,filesep);
                    filename_short = temp{end};
                    fid = fopen(fHEADER,'w');
                        fprintf(fid,'Agency Name,Water Corporation Western Australia\n');
                        
                        fprintf(fid,'Agency Code,WCWA6\n');
                        fprintf(fid,'Program,WCWA6 Phytoplankton\n');
                        fprintf(fid,'Project,WCWA6 Phytoplankton\n');
                        fprintf(fid,'Tag,WCWA6_Phytoplankton_Species\n');
    
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
                        fprintf(fid,'Deployment,%s\n',Deployment);
                        fprintf(fid,'Deployment Position,%s\n',['0.0',VerticalRef]); % '0.0m above Seabed' 0m below surface);
                        fprintf(fid,'Vertical Reference,%s\n',VerticalRef);
                        fprintf(fid,'Site Mean Depth,%4.4f\n',0);
                        %%
    
                        fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                        fprintf(fid,'Contact Email,%s\n','Lachy Gill, uwa email:00114282@uwa.edu.au 13/09/2024');
    
                        %%
                        fprintf(fid,'Variable ID,%s\n',varId);
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
                    fprintf(fid,"%s,%f,%f,N\n",DateStr,Depth,DataVal);
                fclose(fid);
            
            end


        end

            
    end
    fclose(unimprtedFID);
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

function [VarStruct,StructVarIndex] = SearchVarlist(VarListStruct,FileVarHeader)
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
        % disp(FileVarHeader)
        VarStruct = 0;
        StructVarIndex = 0;
        % for StructVarIndex = 1:NumOfVariables
        %     disp(VarListStruct.(VarlistFeilds{StructVarIndex}).Old)
        % end
        % stop
        %not a keyword, intentially stop the code because issue has happend
    end

end

function filenameCell = RecursiveListDataFilesInDir(folderpath)
    folderpath = [folderpath,'**/*.xls'];
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

function    AllNorth = ReadinDataFile(filename)
       
        %IMPORTFILE Import data from a spreadsheet
        %  ALLNORTH = IMPORTFILE(FILE) reads data from the first worksheet in
        %  the Microsoft Excel spreadsheet file named FILE.  Returns the data as
        %  a table.
        %
        %  ALLNORTH = IMPORTFILE(FILE, SHEET) reads from the specified worksheet.
        %
        %  ALLNORTH = IMPORTFILE(FILE, SHEET, DATALINES) reads from the
        %  specified worksheet for the specified row interval(s). Specify
        %  DATALINES as a positive scalar integer or a N-by-2 array of positive
        %  scalar integers for dis-contiguous row intervals.
        %
        %  Example:
        %  AllNorth = importfile("C:\Users\loxte\Downloads\Wamsi 13_08_2024\Phyto\WaterCorp\All North.xls", "231098", [26, 43]);
        %
        %  See also READTABLE.
        %
        % Auto-generated by MATLAB on 13-Sep-2024 11:37:37
        
        %% Input handling
        dataLines = [26, 43];
        workbookFile = filename;
        sheetName = '240299';
    
        
        %% Set up the Import Options and import the data
        opts = spreadsheetImportOptions("NumVariables", 8);
        
        % Specify sheet and range
        opts.Sheet = sheetName;
        opts.DataRange = "B" + dataLines(1, 1) + ":I" + dataLines(1, 2);
        
        % Specify column names and types
        opts.VariableNames = ["VarName2", "Sample", "VarName4", "N1", "VarName6", "VarName7", "N2", "VarName9"];
        opts.VariableTypes = ["char", "char", "char", "double", "double", "char", "double", "double"];
        
        % Specify variable properties
        opts = setvaropts(opts, ["VarName2", "Sample", "VarName4", "VarName7"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["VarName2", "Sample", "VarName4", "VarName7"], "EmptyFieldRule", "auto");
        
        % Import the data
        AllNorth = readtable(workbookFile, opts, "UseExcel", false);
        
        for idx = 2:size(dataLines, 1)
            opts.DataRange = "B" + dataLines(idx, 1) + ":I" + dataLines(idx, 2);
            tb = readtable(workbookFile, opts, "UseExcel", false);
            AllNorth = [AllNorth; tb]; %#ok<AGROW>
        end
        
    
end