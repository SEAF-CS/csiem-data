function ALICEGroups()

    run('../../actions/csiem_data_paths.m')

    main_file = [datapath,'data-lake/ALICE/20110728_Swan River Master Data_ all data P1 to P3-1.xlsx'];
    outdir = [datapath,'data-warehouse/csv/alice1/Groups/'];



    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../actions/varkey.mat;
    load ../../actions/agency.mat;
    load ../../actions/sitekey.mat;

    VarListStruct = agency.ALICE1Group;
    SiteListStruct = sitekey.SWANEST;
    %   Shares all the same sites as swanest


    unimprtedFID = fopen(['UnimportedGroups.txt'],"w");

    opts = detectImportOptions(main_file,'Sheet','P3_Bio-Nov');
    opts.VariableTypes{1, 2} = 'datetime'; %date
    opts.VariableTypes{1, 8} = 'double';  %bottom depth

    DataTable = readtable(main_file,opts);



    Sites = DataTable{:,1};
    [UniqueSites, ISites,IUniqueSites] = unique(Sites);
    for sitenum = 1:length(UniqueSites)
        %workout what site
        SiteName = UniqueSites{sitenum}; %Col 2 is Site name
        SiteStruct = SearchSitelistbyStr(SiteListStruct,SiteName);
        CurentSites = IUniqueSites == sitenum;

        DateCol = DataTable{CurentSites,2}; %col 2
        DateCol.Format = 'yyyy-MM-dd HH:mm:ss';
        MeasureingDepth = DataTable{CurentSites,7}; 

        for varIndex = [9:18] %this is the array of indexes of the variables I want in the variable "DataTables"
            varname =  DataTable.Properties.VariableDescriptions{varIndex};
            [AgencyStruct,AgencyIndex] = SearchVarlist(VarListStruct,varname);
            if AgencyIndex == 0 
                fprintf(unimprtedFID,"%s\n",varname);
                continue
            end

            varId = AgencyStruct.ID;
            VarStruct = varkey.(varId);
            Conv = AgencyStruct.Conv; 
            DataVal = DataTable{CurentSites,varIndex}*Conv; % DataTable.("SpeciesDensityCells_ml")(row)
            if isnan(DataVal)
                continue    
            end

            [fDATA,fHEADER] = filenamecreator(outdir,SiteStruct,VarStruct);

                heightOrdepth = 'Depth';
                Deployment = 'Floating';
                %only gets in here when file doesnt exist already
                fid = fopen(fDATA,'W');
                fprintf(fid,"Date,%s,Data,QC\n",heightOrdepth);
                for n = 1:sum(CurentSites)%need \s to loop over all elements in Current SItes
                    fprintf(fid,"%s,%f,%f,N\n",DateCol(n),MeasureingDepth(n),DataVal(n));
                end
                fclose(fid);

    
                temp = split(fDATA,filesep);
                filename_short = temp{end};
                fid = fopen(fHEADER,'w');
                    fprintf(fid,'Agency Name,ALICE\n');
                    
                    fprintf(fid,'Agency Code,ALICE\n');
                    fprintf(fid,'Program,ALICE\n');
                    fprintf(fid,'Project,ALICE\n');
                    fprintf(fid,'Tag,ALICE_Plankton_Group\n');
    
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
                    fprintf(fid,'Deployment Position,%s\n','0.0m below surface'); % '0.0m above Seabed' 0m below surface);
                    fprintf(fid,'Vertical Reference,%s\n','Water Surface');
                    fprintf(fid,'Site Mean Depth,%4.4f\n',0);
                    %%
    
                    fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                    fprintf(fid,'Contact Email,%s\n','Lachy Gill, uwa email:00114282@uwa.edu.au 17/09/2024');
    
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
    opts = spreadsheetImportOptions("NumVariables", 14);
    
    % Specify sheet and range
    opts.Sheet = sheetName;
    opts.DataRange = "B" + dataLines(1, 1) + ":O" + dataLines(1, 2);
    
    % Specify column names and types
    opts.VariableNames = ["VarName2", "Sample", "VarName4", "North", "VarName6", "VarName7", "North1", "VarName9", "VarName10", "North2", "VarName12", "VarName13", "North3", "VarName15"];
    opts.VariableTypes = ["char", "char", "char", "double", "double", "char", "double", "double", "char", "double", "double", "char", "double", "double"];
    
    % Specify variable properties
    opts = setvaropts(opts, ["VarName2", "Sample", "VarName4", "VarName7", "VarName10", "VarName13"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["VarName2", "Sample", "VarName4", "VarName7", "VarName10", "VarName13"], "EmptyFieldRule", "auto");
    
    % Import the data
    AllNorthS6 = readtable(workbookFile, opts, "UseExcel", false);
    
    for idx = 2:size(dataLines, 1)
        opts.DataRange = "B" + dataLines(idx, 1) + ":O" + dataLines(idx, 2);
        tb = readtable(workbookFile, opts, "UseExcel", false);
        AllNorthS6 = [AllNorthS6; tb]; %#ok<AGROW>
    end
    
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