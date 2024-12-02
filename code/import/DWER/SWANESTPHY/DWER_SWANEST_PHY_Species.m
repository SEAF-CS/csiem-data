function DWER_SWANEST_PHY_Species()

    run('../../../actions/csiem_data_paths.m')

    main_file = [datapath,'data-lake/DWER/SCE/phytoplankton/ALL PROGRAMS - PHYTO AWARE_2012-2020.xlsx'];
    outdir = [datapath,'data-warehouse/csv/dwer/swanest/phy/species/'];


    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../../actions/varkey.mat;
    load ../../../actions/agency.mat;
    load ../../../actions/sitekey.mat;

    VarListStruct = agency.SWANESTSpecies;
    SiteListStruct = sitekey.SWANEST;

    varnameInsideAgencyStruct = fieldnames(VarListStruct);

    unimprtedFID = fopen(['UnimportedSpecies.txt'],"w");


    DataTable = readtable(main_file);


    % %% for speed finding all variable id's at the start
    % varIds = cell(height(DataTable),1);
    % AgencyIndexs = nan(height(DataTable),1);
    % for rowNum = 1:height(DataTable)
    %     % match to varkey
    %     varname =  DataTable{rowNum,13}; % col 13
    %     [AgencyStruct,AgencyIndex] = SearchVarlist(VarListStruct,varname);
    %     if AgencyIndex == 0 
    %         fprintf(unimprtedFID,"%s\n",varname{1});
    %         varIds{rowNum} = '0';
    %         AgencyIndexs(rowNum) = 0;
    %         %% this is used to skip groups in the species code
    %         continue
    %     end
    %     varIds{rowNum} = AgencyStruct.ID;
    %     AgencyIndexs(rowNum) = AgencyIndex;
        
    % end
    RAWtimes = DataTable.("Time"); %col 11, matlab reads in as decimal out of 24 hours
    DateCol = DataTable.("DateCollected"); %col 1, matlab reads this in as a datetime.

    %Some of the data points didnt have times, making them midnight.
    NoTimeValuesInds = isnan(RAWtimes);
    RAWtimes(NoTimeValuesInds) = 0;

    % matlab behaviour treats date times as a number of days since arbitrary point, so adding RAWtimes to DateCol gives desired output.
    DateStr = DateCol+RAWtimes;
    DateStr.Format = 'yyyy-MM-dd HH:mm:ss';
    RawDepth = DataTable{:,12}; 
    DepthVec = sscanf(sprintf(' %s',RawDepth{:}),'%f',[1,Inf])';


    for row = 1:height(DataTable)
        varname =  DataTable{row,13}; % col 13
        [AgencyStruct,AgencyIndex] = SearchVarlist(VarListStruct,varname);
        if AgencyIndex == 0 
            fprintf(unimprtedFID,"%s\n",varname{1});
            continue
        end

        SiteName = DataTable{row,2}; %Col 2 is Site name

        SiteStruct = SearchSitelistbyStr(SiteListStruct,SiteName);
        
        varId = AgencyStruct.ID;
        VarStruct = varkey.(varId);
        Conv = AgencyStruct.Conv; 
        Depth = sprintf("0-%.2f",DepthVec(row));
        DataVal = DataTable{row,17}*Conv; % DataTable.("SpeciesDensityCells_ml")(row)
        if isnan(DataVal)
            continue    
        end

        [fDATA,fHEADER] = filenamecreator(outdir,SiteStruct,VarStruct);

        if ~exist(fDATA,'file')
            heightOrdepth = 'Depth';
            Deployment = 'Integrated';
            %only gets in here when file doesnt exist already
            fid = fopen(fDATA,'W');
            fprintf(fid,"Date,%s,Data,QC\n",heightOrdepth);
            fclose(fid);

            temp = split(fDATA,filesep);
            filename_short = temp{end};
            fid = fopen(fHEADER,'w');
                fprintf(fid,'Agency Name,Department of Water and Environmental Regulation\n');
                
                fprintf(fid,'Agency Code,DWER\n');
                fprintf(fid,'Program,SCE\n');
                fprintf(fid,'Project,phytoplankton\n');
                fprintf(fid,'Tag,DWER-SWANEST-PHY\n');

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
                fprintf(fid,'Deployment Position,%s\n','Depth Range'); % '0.0m above Seabed' 0m below surface);
                fprintf(fid,'Vertical Reference,%s\n','Water Surface');
                fprintf(fid,'Site Mean Depth,%4.4f\n',0);
                %%

                fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                fprintf(fid,'Contact Email,%s\n','Lachy Gill <00114282@uwa.edu.au> 13/09/2024');

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
            fprintf(fid,"%s,%s,%f,N\n",DateStr(row),Depth,DataVal);
        fclose(fid);
    
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