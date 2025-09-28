%  function import_phytoplankton_GroupStaging()

    run('../../../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-lake/WCWA/PLOOM/Phyto/16/All South LachyEdits.xlsx'];
    outdir = [datapath,'data-warehouse/csv/wcwa/ploom/phy/group/16-22/'];


    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../../../actions/varkey.mat;
    load ../../../../actions/agency.mat;
    load ../../../../actions/sitekey.mat;

    VarListStruct = agency.WCWA16_PhytoplanktonGroup;
    SiteListStruct = sitekey.WCWA16Phyto;
    varnameInsideAgencyStruct = fieldnames(VarListStruct);

    ProcessSheet(main_dir,'271098',outdir,47,VarListStruct,SiteListStruct,varkey);
    ProcessSheet(main_dir,'031298',outdir,52,VarListStruct,SiteListStruct,varkey);
    ProcessSheet(main_dir,'220199',outdir,50,VarListStruct,SiteListStruct,varkey);
    ProcessSheet(main_dir,'230299',outdir,39,VarListStruct,SiteListStruct,varkey);
    ProcessSheet(main_dir,'240399',outdir,41,VarListStruct,SiteListStruct,varkey);
    ProcessSheet(main_dir,'040599',outdir,68,VarListStruct,SiteListStruct,varkey);
    ProcessSheet(main_dir,'080799',outdir,63,VarListStruct,SiteListStruct,varkey);

% end

function ProcessSheet(filename,SheetString,outdir,ExcelIndexOfEndofTable,VarListStruct,SiteListStruct,varkey)
    ExcelLineNumberstart = 26;
    NumberOfElements = ExcelIndexOfEndofTable-ExcelLineNumberstart+1;

    DataTable = importfile(filename,SheetString, [26,ExcelIndexOfEndofTable]); %this works in excel indexes
    SiteandDate = importMetaData(filename,SheetString);
    SiteColNums = [4,7,10,13]; %hard coded to match DataTable variable
    NumofSites = length(SiteColNums);

    %% Site search
    % All variables have same order of Sites, determine site once at begging
    for siteNum = 1:NumofSites
        SiteCol = SiteColNums(siteNum);
        SiteName = SiteandDate{1,SiteCol-3}; 
        % metadata table starts at the data hence is shifted back 3, and stores site in top row and then date
        SiteStructList{siteNum} = SearchSitelistbyStr(SiteListStruct,SiteName);

        t = SiteandDate{2,SiteCol-3};
        DateStrList{siteNum} = datetime(t,'InputFormat','MMMM dd yyyy');
        DateStrList{siteNum}.Format = 'yyyy-MM-dd HH:mm:ss';
    end

    for i = 1:NumberOfElements
        %%  Var search
        [AgencyStruct ,Index] = SearchVarlist(VarListStruct,DataTable{i,1});
        %check its valid
        if ~Index
            continue
        end
        varId = AgencyStruct.ID;
        VarStruct = varkey.(varId);
        Conv = AgencyStruct.Conv; 
        Depth = 0;

        for  siteNum = 1:NumofSites
            SiteCol = SiteColNums(siteNum);
            CellConcentration = DataTable{i,SiteCol}*Conv;
            if isnan(CellConcentration)
                continue    
            end

            [fDATA,fHEADER] = filenamecreator(outdir,SiteStructList{siteNum},VarStruct);

            % check if this is first sheet
            if ~exist(fDATA,'file')
                heightOrdepth = 'Depth';
                CreateHeaderFile(fDATA,fHEADER,SiteStructList{siteNum},varId,VarStruct,heightOrdepth)

                fid = fopen(fDATA,'W');
                fprintf(fid,"Date,%s,Data,QC\n",heightOrdepth);
                fclose(fid);
            end

            % append data
            fid =fopen(fDATA,'a');
            fprintf(fid,'%s,%f,%f,N\n',DateStrList{siteNum},Depth,CellConcentration);
            fclose(fid);


        end
    end
end

function CreateHeaderFile(fDATA,fHEADER,SiteStruct,varId,VarStruct,heightOrdepth)          
    Deployment = 'Integrated';
    VerticalRef = 'Water Column';
    temp = split(fDATA,filesep);
    filename_short = temp{end};
    fid = fopen(fHEADER,'w');
        fprintf(fid,'Agency Name,Water Corporation WA\n');
        
        fprintf(fid,'Agency Code,WCWA\n');
        fprintf(fid,'Program,PLOOM\n');
        fprintf(fid,'Project,Phyto\n');
        fprintf(fid,'Tag,WCWA-PLOOM-PHY\n');

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
        fprintf(fid,'Deployment Position,%s\n',[VerticalRef]); % '0.0m above Seabed' 0m below surface);
        fprintf(fid,'Vertical Reference,%s\n','m below Surface');
        fprintf(fid,'Site Mean Depth,%4.4f\n',0);
        %%

        fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
        fprintf(fid,'Contact Email,%s\n','Lachy Gill <00114282@uwa.edu.au> 13/02/2025');

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
    filevar = regexprep(filevar,'\/','.');
    filesite = SiteStruct.AED;

    base = [outpath,filesite,'_',filevar];
    data = [base,'_DATA.csv'];
    header = [base,'_HEADER.csv'];

end


function AllNorthS6 = importfile(workbookFile, sheetName, dataLines)
    %IMPORTFILE Import data from a spreadsheet
    %  ALLNORTHS6 = IMPORTFILE(FILE) reads data from the first worksheet in
    %  the Microsoft Excel spreadsheet file named FILE.  Returns the data as
    %  a table.
    %
    %  ALLNORTHS6 = IMPORTFILE(FILE, SHEET) reads from the specified
    %  worksheet.
    %
    %  ALLNORTHS6 = IMPORTFILE(FILE, SHEET, DATALINES) reads from the
    %  specified worksheet for the specified row interval(s). Specify
    %  DATALINES as a positive scalar integer or a N-by-2 array of positive
    %  scalar integers for dis-contiguous row intervals.
    %
    %  Example:
    %  AllNorthS6 = importfile("C:\Users\loxte\Downloads\Wamsi 13_08_2024\Phyto\WaterCorp\All North.xls", "240699", [26, 56]);
    %
    %  See also READTABLE.
    %
    % Auto-generated by MATLAB on 13-Sep-2024 16:48:49
    
    %% Input handling
    
    % If no sheet is specified, read first sheet
    if nargin == 1 || isempty(sheetName)
        sheetName = 1;
    end
    
    % If row start and end points are not specified, define defaults
    if nargin <= 2
        dataLines = [26, 56];
    end
    
    %% Set up the Import Options and import the data
    opts = detectImportOptions(workbookFile,"NumVariables", 14);
    
    % Specify sheet and range
    opts.Sheet = sheetName;
    
    
    % Specify column names and types
    opts.VariableNames = ["VarName2", "Sample", "VarName4", "North", "VarName6", "VarName7", "North1", "VarName9", "VarName10", "North2", "VarName12", "VarName13", "North3", "VarName15"];
    opts.VariableTypes = ["char", "char", "char", "double", "double", "char", "double", "double", "char", "double", "double", "char", "double", "double"];
    opts.DataRange = "B" + dataLines(1, 1) + ":O" + dataLines(1, 2);
    
    % Specify variable properties
    opts = setvaropts(opts, ["VarName2", "Sample", "VarName4", "VarName7", "VarName10", "VarName13"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["VarName2", "Sample", "VarName4", "VarName7", "VarName10", "VarName13"], "EmptyFieldRule", "auto");
    
    % Import the data
    AllNorthS6 = readtable(workbookFile, opts, "UseExcel", false);
    
    % for idx = 2:size(dataLines, 1)
    %     opts.DataRange = "B" + dataLines(idx, 1) + ":O" + dataLines(idx, 2);
    %     tb = readtable(workbookFile, opts, "UseExcel", false);
    %     AllNorthS6 = [AllNorthS6; tb]; %#ok<AGROW>
    % end
    
    end

function AllNorthS6 = importMetaData(filename,sheetName)
        opts = spreadsheetImportOptions("NumVariables", 10);

        % Specify sheet and range
        opts.Sheet = sheetName;
        opts.DataRange = "E12:N13";

        % Specify column names and types
        opts.VariableNames = ["North", "VarName6", "VarName7", "North_1", "VarName9", "VarName10", "North_2", "VarName12", "VarName13", "North_3"];
        opts.VariableTypes = ["char", "char", "char", "char", "char", "char", "char", "char", "char", "char"];

        % Specify variable properties
        opts = setvaropts(opts, ["North", "VarName6", "VarName7", "North_1", "VarName9", "VarName10", "North_2", "VarName12", "VarName13", "North_3"], "WhitespaceRule", "preserve");
        opts = setvaropts(opts, ["North", "VarName6", "VarName7", "North_1", "VarName9", "VarName10", "North_2", "VarName12", "VarName13", "North_3"], "EmptyFieldRule", "auto");

        % Import the data
        AllNorthS6 = readtable(filename, opts, "UseExcel", false);

        %% Convert to output type
        AllNorthS6 = table2cell(AllNorthS6);
        numIdx = cellfun(@(x) ~isnan(str2double(x)), AllNorthS6);
        AllNorthS6(numIdx) = cellfun(@(x) {str2double(x)}, AllNorthS6(numIdx));

end