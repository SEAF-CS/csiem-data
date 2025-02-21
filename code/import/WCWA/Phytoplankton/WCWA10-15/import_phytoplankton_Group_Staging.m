function import_phytoplankton_Group_Staging()

    run('../../../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-lake/WCWA/PLOOM/Phyto/3/All North.xls'];
    outdir = [datapath,'data-warehouse/csv_holding/wcwa/ploom/phy/group/10-15/'];
    filename = main_dir;

    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    SheetString = '310899';
    DateStr = '1999-08-31 00:00:00';
    SiteIndexes = [6,9,12,15];
    SheetTable = importfile(filename,SheetString, [3,300]);
        StageFromSheetTable(SheetTable,DateStr,52,'Bacillariophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,56,'Choanoflagellidea (zooplankton)',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,61,'Cryptophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,65,'Cyanophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,70,'Dictyochophyceae'        ,SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,88,'Dinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,92,'Euglenophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,96,'Prasinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,100,'Raphidophyceae',SiteIndexes,outdir);

    
    SheetString = '211099';
    DateStr = '1999-10-21 00:00:00';
    SiteIndexes = [6,9,12,15];
    SheetTable = importfile(filename,SheetString, [3,300]);
        StageFromSheetTable(SheetTable,DateStr,66,'Bacillariophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,70,'Chrysophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,75,'Choanoflagellidea (zooplankton)',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,81,'Cryptophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,85,'Cyanophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,92,'Dictyochophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,120,'Dinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,124,'Euglenophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,129,'Prasinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,133,'Prymnesiophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,138,'Raphidophyceae',SiteIndexes,outdir);


    SheetString = '031299';
    DateStr = '1999-03-12 00:00:00';
    SiteIndexes = [6,9,12,15];
    SheetTable = importfile(filename,SheetString, [3,300]);
        StageFromSheetTable(SheetTable,DateStr,52,'Bacillariophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,78,'Chlorophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,82,'Chrysophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,87,'Choanoflagellidea (zooplankton)',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,94,'Cryptophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,98,'Cyanophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,106,'Dictyochophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,134,'Dinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,138,'Euglenophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,143,'Prasinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,150,'Prymnesiophyceae',SiteIndexes,outdir);        
        StageFromSheetTable(SheetTable,DateStr,155,'Raphidophyceae',SiteIndexes,outdir);


    SheetString = '250100';
    DateStr = '2000-01-25 00:00:00';
    SiteIndexes = [6,9,12,15];
    SheetTable = importfile(filename,SheetString, [3,300]);
        StageFromSheetTable(SheetTable,DateStr,76,'Bacillariophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,80,'Chlorophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,84,'Chrysophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,89,'Choanoflagellidea (zooplankton)',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,96,'Cryptophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,101,'Cyanophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,109,'Dictyochophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,137,'Dinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,141,'Euglenophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,146,'Prasinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,153,'Prymnesiophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,158,'Raphidophyceae',SiteIndexes,outdir);


    SheetString = '030300';
    DateStr = '2000-03-03 00:00:00';
    SiteIndexes = [7,11,15,19];
    SheetTable = importfile(filename,SheetString, [3,300]);
    StageFromSheetTable(SheetTable,DateStr,82,'Bacillariophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,86,'Chlorophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,90,'Chrysophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,95,'Choanoflagellidea (zooplankton)',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,102,'Cryptophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,107,'Cyanophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,115,'Dictyochophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,143,'Dinophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,147,'Euglenophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,152,'Prasinophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,160,'Prymnesiophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,165,'Raphidophyceae',SiteIndexes,outdir);
 

    
    SheetString = '220300';
    DateStr = '2000-03-22 00:00:00';
    SiteIndexes = [7,11,15,19];
    SheetTable = importfile(filename,SheetString, [3,300]);

    nums = [87,91,95,100,107,112,120,149,163,158,166,171];
    Names = {...
    'Bacillariophyceae',...
    'Chlorophyceae',...
    'Chrysophyceae',...
    'Choanoflagellidea (zooplankton)',...
    'Cryptophyceae',...
    'Cyanophyceae',...
    'Dictyochophyceae',...
    'Dinophyceae',...
    'Euglenophyceae',...
    'Prasinophyceae',...
    'Prymnesiophyceae',...
    'Raphidophyceae',...
    };
    for i = 1:length(nums)
        StageFromSheetTable(SheetTable,DateStr,nums(i),Names{i},SiteIndexes,outdir);
    end

    % StageFromSheetTable(SheetTable,DateStr,,SiteIndexes,outdir);       
end

function StageFromSheetTable(SheetTable,DateStr,ExcelLineNumber,NameInExcel,SiteIndexes,outdir)
    LineNumberInSheetTable = ExcelLineNumber-2;

    for  siteNum = 1:length(SiteIndexes)
        siteIndex = SiteIndexes(siteNum);
        CellConcentration = SheetTable{LineNumberInSheetTable,siteIndex};
        fname = sprintf("%s%s_N%d.csv",outdir,NameInExcel,siteNum);
        fid = fopen(fname,'a+');
        fprintf(fid,"%s,0,%f,N\n",DateStr,CellConcentration);
        fclose(fid);
    end
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
    opts = spreadsheetImportOptions("NumVariables", 19);
    
    % Specify sheet and range
    opts.Sheet = sheetName;
    opts.DataRange = "A" + dataLines(1) + ":S" + dataLines(2);
    
    % Specify column names and types
    opts.VariableNames = ["Taxon","t1","t2","N1-Total","N1-%","N1-Cells/ml","N2-Total","N2-%", "N2-Cells/ml",	"N3-Total",	"N3-%",	"N3-Cells/ml","N4-Total","N4-%","N4-Cells/ml","t3","t4","t5","t6"];
    opts.VariableTypes = ["char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double","double","double","double","double","double"];
    
    % Specify variable properties
 
    opts = setvaropts(opts, opts.VariableNames, "EmptyFieldRule", "auto");
    
    % Import the data
    AllNorthS6 = readtable(workbookFile, opts, "UseExcel", false);
    
end