%function ALICESpecies()
%function ALICESpecies()
    run('../../../../../actions/csiem_data_paths.m')

    main_file = [datapath,'data-lake/UWA/AED/swan-phytoplankton/Phyto Species List_Calculation Sheet_Swan_master.xls'];
    outdir = [datapath,'data-warehouse/csv/uwa/aed/phy/Species/1/'];



    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../../../../actions/varkey.mat;
    load ../../../../../actions/agency.mat;
    load ../../../../../actions/sitekey.mat;

    VarListStruct = agency.UWA_AED_PHY_1_Species;
    SiteListStruct = sitekey.SWANEST;
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
    StopBvec = StartBvec + 217-115;

    opts = spreadsheetOptions();

    for sheetNum = 1:NumofSheets
        [Surface,Bottom,Date] = SheetFunction(main_file,opts,SheetNames(sheetNum),...
        StartSvec(sheetNum),...
        StopSvec(sheetNum),...
        StartBvec(sheetNum),...
        StopBvec(sheetNum));

        SitesNames = Surface.Properties.VariableNames';

        if height(Surface) ~= height(Bottom)
            fprintf('This Sheet has diff bot vs surf %d\n',sheetNum);
        end

        for col = 11:16 %hardcoded to match file 
            % this iterates over sites

            verboseName = SitesNames{col};
            Site = verboseName(1:end-2);
            SiteStruct = SiteListStruct.(Site);

            %Site depth is slow so only do it once per site ans save result
            if sheetNum ==1 
                %search for sites depth
                BotDepth = BottomDepthFunc(SiteStruct);

                %Note to self-> for additional performance gains rewriting BottomDepthFunc to receive the 3 bathymetry
                % files would mean i dont need to load them 6 time
                % which could have potential benefits, depending on whicj is the slow part of this function (Its not been profiled)
                BotDepthList(col) = BotDepth; 
            else 
                %grab sites depth from list
                BotDepth = BotDepthList(col);
            end

        

            for SpeciesNum = 1:height(Surface)
                % check surface and bottom for NAN
                SURFBOOL = ~isnan(Surface{SpeciesNum,col});
                BOTTBOOL = ~isnan(Bottom{SpeciesNum,col});

                %Or gate for creating header and datafile
                if SURFBOOL | BOTTBOOL
                    %find varStruct
                    varname =  Surface{SpeciesNum,2}{1};

                    [AgencyStruct,AgencyIndex] = SearchVarlist(VarListStruct,varname);
                    if AgencyIndex == 0 
                        fprintf(unimprtedFID,"%s\n",varname);
                        continue
                    end
                    %create header and dataheader
                    fDATA = CreateHeaderFileAndFileHeader(outdir,AgencyStruct,SiteStruct,varkey);
                    %only thing that needs more info is data, return fDATA.
                end

                %both values need to multiplied by Conv
                Conv = AgencyStruct.Conv;

                if SURFBOOL
                    Depth = 0.5;
                    DataVal = Surface{SpeciesNum,col}*Conv;
                    

                    fid = fopen(fDATA,'a');                    
                    fprintf(fid,"%s,%f,%f,N\n",Date,Depth,DataVal);
                    fclose(fid);
                end

                %if bottom append bottom
                if BOTTBOOL
                    DataVal = Bottom{SpeciesNum,col}*Conv;

                    %BotDepth is calculated at the top of the Site for loop, because this is the same for all variables from the same site.
                    %we know phyto concentration is measured 0.5m off the seafloor.
                    if ~isnan(BotDepth)
                        %Known seafloor depth
                        Depth = BotDepth-0.5;
                        fid = fopen(fDATA,'a');                    
                        fprintf(fid,"%s,%f,%f,N\n",Date,Depth,DataVal);
                        fclose(fid);
                    else
                        %Unknown seafloor depth (we still know its 0.5 above seafloor)
                        fid = fopen(fDATA,'a');                    
                        fprintf(fid,"%s,%s,%f,N\n",Date,"N/A",DataVal);
                        fclose(fid);
                  
                    end
                    
                end

                        
            end
            % error('finished first lap of all species')


        end
        fprintf(unimprtedFID,"@@@");
    end
  

    fclose(unimprtedFID);
%end

function BotDepth = BottomDepthFunc(SiteStruct)
    Lat = SiteStruct.Lat;
    Lon = SiteStruct.Lon;
    if Lat == -1 & Lon == -1
        BotDepth = NaN;
    else
        BotDepth = CalcDepthViaSMD_Code(SiteStruct.Lat,SiteStruct.Lon);
    end
end


function fDATA = CreateHeaderFileAndFileHeader(outdir,AgencyStruct,SiteStruct,varkey)

    varId = AgencyStruct.ID;
    VarStruct = varkey.(varId);

    [fDATA,fHEADER] = filenamecreator(outdir,SiteStruct,VarStruct);

    if ~exist(fHEADER,'file')
        % this is when files dont exist and need to be created
        heightOrdepth = 'Depth';
        Deployment = 'Floating';
    
        fid = fopen(fDATA,'W');
        fprintf(fid,"Date,%s,Data,QC\n",heightOrdepth);
        fclose(fid);

        temp = split(fDATA,filesep);
        filename_short = temp{end};
        fid = fopen(fHEADER,'w');
            fprintf(fid,'Agency Name,University of Western Australia\n');
            
            fprintf(fid,'Agency Code,UWA\n');
            fprintf(fid,'Program,AED\n');
            fprintf(fid,'Project,swan-phytoplankton\n');
            fprintf(fid,'Tag,UWA-AED-PHY\n');

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
            fprintf(fid,'Deployment Position,%s\n','0.0m below Surface'); % '0.0m above Seabed' 0m below surface);
            fprintf(fid,'Vertical Reference,%s\n','m below Surface');
            fprintf(fid,'Site Mean Depth,%4.4f\n',0);
            %%

            fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
            fprintf(fid,'Contact Email,%s\n','Lachy Gill <00114282@uwa.edu.au> 25/09/2024');

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

function PrintToFile()
end


function opts = spreadsheetOptions()
    % Headers.txt is a csv that i have copied the site names into. the xls has 2 empty cells that are hidden. so just adding those in too
    T = readcell('Headers.txt');
    T = {T{1:8},' ',' ',T{9:end}};
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

    Date = readcell(main_file,'Sheet',sheetname,'DataRange','B2:B2');
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
        if strcmp(FileVarHeader,strip(StructVarHeader))
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