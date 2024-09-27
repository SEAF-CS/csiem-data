%function ALICESpecies()
%function ALICESpecies()
    run('../../actions/csiem_data_paths.m')

    main_file = [datapath,'data-lake/ALICE/Phyto Species List_Calculation Sheet_Swan_master.xls'];
    outdir = [datapath,'data-warehouse/csv/alice1/Species/'];



    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../actions/varkey.mat;
    load ../../actions/agency.mat;
    load ../../actions/sitekey.mat;

    VarListStruct = agency.ALICE1Species;
    SiteListStruct = sitekey.SWANEST
    %   Shares all the same sites as swanest


    unimprtedFID = fopen(['UnimportedSpecies.txt'],"w");

    SheetNames = sheetnames(main_file);
    NumofSheets = length(SheetNames)-2; %the last 2 are summaries not raw data
    
    %Hardcoded linenums
    StartSvec = 8*ones(NumofSheets,1);
    StartSvec(1)=7;
    StopSvec = StartSvec+109-7;

    StartBvec = 117*ones(NumofSheets,1);
    StartBvec(1) = 115;
    StopBvec = StartBvec + 217-117;

    opts = spreadsheetOptions();

    for sheetNum = 1:NumofSheets
        [Surface,Bottom,Date] = SheetFunction(main_file,opts,SheetNames(sheetNum),...
        StartSvec(sheetNum),...
        StopSvec(sheetNum),...
        StartBvec(sheetNum),...
        StopBvec(sheetNum));
        SitesNames = Surface.Properties.VariableNames';

        for col = 11:16 %hardcoded to match file 
            % this iterates over sites
            verboseName = SitesNames{col};
            Site = verboseName(1:end-2);
            SiteStruct = SiteListStruct.(Site);

            for SpeciesNum = 1:height(Surface)
                varname =  Surface{SpeciesNum,2}{1}; % col 2 or 'Species'
                [AgencyStruct,AgencyIndex] = SearchVarlist(VarListStruct,varname);
                if AgencyIndex == 0 
                    fprintf(unimprtedFID,"%s\n",varname);
                    continue
                end

                varId = AgencyStruct.ID;
                VarStruct = varkey.(varId);
                Conv = AgencyStruct.Conv; 
                DataVal = Surface{SpeciesNum,col}*Conv; % DataTable.("SpeciesDensityCells_ml")(row)
                if isnan(DataVal)
                    continue    
                end
                [fDATA,fHEADER] = filenamecreator(outdir,SiteStruct,VarStruct);
                if sheetNum == 1
                    % this is when files need to be created
                    %only gets in here when file doesnt exist already
                    heightOrdepth = 'Depth';
                    Deployment = 'Floating';
                
                    fid = fopen(fDATA,'W');
                    fprintf(fid,"Date,%s,Data,QC\n",heightOrdepth);
                    fclose(fid);

                    temp = split(fDATA,filesep);
                    filename_short = temp{end};
                    fid = fopen(fHEADER,'w');
                        fprintf(fid,'Agency Name,ALICE\n');
                        
                        fprintf(fid,'Agency Code,ALICE\n');
                        fprintf(fid,'Program,ALICE\n');
                        fprintf(fid,'Project,ALICE\n');
                        fprintf(fid,'Tag,ALICE_Plankton_Species\n');
        
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
                        fprintf(fid,'Contact Email,%s\n','Lachy Gill, uwa email:00114282@uwa.edu.au 25/09/2024');
        
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
                Depth = 0;
                fprintf(fid,"%s,%f,%f,N\n",Date,Depth,DataVal);
                fclose(fid);
                
            end


        end

    end
  

    fclose(unimprtedFID);
%end

function opts = spreadsheetOptions()
    T = readcell('Headers.txt');
    T = {T{1:8},' ',' ',T{10:end}};
    opts = spreadsheetImportOptions('NumVariables',22,...
                                'VariableNames',T,...
                                'VariableTypes',{'char','char','int32','int32','int32','int32','int32','int32','int32','int32','double','double','double','double','double','double','double','double','double','double','double','double'}...
                                ); 

end

function [Surface,Bottom,Date] = SheetFunction(main_file,opts,sheetname,start1,stop1,start2,stop2)
    opts.Sheet = sheetname;
    opts.DataRange = sprintf("A%d:V%d",start1,stop1);
    Surface = readtable(main_file,opts);

    opts.DataRange = sprintf("A%d:V%d",start2,stop2);
    Bottom = readtable(main_file,opts);

    Date = readcell(main_file,'DataRange','B2:B2');
    Date = Date{1};
    Date.Format = 'yyyy-MM-dd HH:mm:ss';
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