function import_phytoplankton_Group_Staging()

    run('../../../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-lake/WCWA/PLOOM/Phyto/16/All South LachyEdits.xlsx'];
    outdir = [datapath,'data-warehouse/csv_holding/wcwa/ploom/phy/group/23-28/'];
    filename = main_dir;

    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    SheetString = '010999';
    DateStr = '1999-09-01 00:00:00';
    SiteIndexes = [6,9,12,15];
    SheetTable = importfile(filename,SheetString, [3,300]);
        StageFromSheetTable(SheetTable,DateStr,54,'Bacillariophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,58,'Chrysophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,63,'Choanoflagellidea (zooplankton)',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,69,'Cryptophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,73,'Cyanophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,80,'Dictyochophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,103,'Dinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,107,'Euglenophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,112,'Prasinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,117,'Raphidophyceae',SiteIndexes,outdir);

    
    SheetString = '051199';
    DateStr = '1999-11-05 00:00:00';
    SiteIndexes = [6,9,12,15];
    SheetTable = importfile(filename,SheetString, [3,300]);
        StageFromSheetTable(SheetTable,DateStr,65,'Bacillariophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,69,'Chrysophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,74,'Choanoflagellidea (zooplankton)',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,80,'Cryptophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,84,'Cyanophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,91,'Dictyochophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,119,'Dinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,123,'Euglenophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,128,'Prasinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,132,'Prymnesiophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,137,'Raphidophyceae',SiteIndexes,outdir);


    SheetString = '151299';
    DateStr = '1999-12-15 00:00:00';
    SiteIndexes = [6,9,12,15];
    SheetTable = importfile(filename,SheetString, [3,300]);
        StageFromSheetTable(SheetTable,DateStr,74,'Bacillariophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,78,'Chlorophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,82,'Chrysophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,87,'Choanoflagellidea (zooplankton)',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,94,'Cryptophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,98,'Cyanophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,105,'Dictyochophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,133,'Dinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,137,'Euglenophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,142,'Prasinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,149,'Prymnesiophyceae',SiteIndexes,outdir);        
        StageFromSheetTable(SheetTable,DateStr,154,'Raphidophyceae',SiteIndexes,outdir);


    SheetString = '280100';
    DateStr = '2000-01-28 00:00:00';
    SiteIndexes = [6,9,12,15];
    SheetTable = importfile(filename,SheetString, [3,300]);
        StageFromSheetTable(SheetTable,DateStr,78,'Bacillariophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,82,'Chlorophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,86,'Chrysophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,91,'Choanoflagellidea (zooplankton)',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,98,'Cryptophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,102,'Cyanophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,109,'Dictyochophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,137,'Dinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,141,'Euglenophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,146,'Prasinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,154,'Prymnesiophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,159,'Raphidophyceae',SiteIndexes,outdir);

    SheetString = '080200';
    DateStr = '2000-02-08 00:00:00';
    SiteIndexes = [7,11,15,19];
    SheetTable = importfile(filename,SheetString, [3,300]);
        StageFromSheetTable(SheetTable,DateStr,81,'Bacillariophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,85,'Chlorophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,89,'Chrysophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,94,'Choanoflagellidea (zooplankton)',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,101,'Cryptophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,105,'Cyanophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,112,'Dictyochophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,140,'Dinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,144,'Euglenophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,149,'Prasinophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,158,'Prymnesiophyceae',SiteIndexes,outdir);
        StageFromSheetTable(SheetTable,DateStr,163,'Raphidophyceae',SiteIndexes,outdir);

    SheetString = '300300';
    DateStr = '2000-03-30 00:00:00';
    SiteIndexes = [7,11,15,19];
    SheetTable = importfile(filename,SheetString, [3,300]);
    StageFromSheetTable(SheetTable,DateStr,88,'Bacillariophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,92,'Chlorophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,96,'Chrysophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,101,'Choanoflagellidea (zooplankton)',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,108,'Cryptophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,113,'Cyanophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,120,'Dictyochophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,148,'Dinophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,152,'Euglenophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,157,'Prasinophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,166,'Prymnesiophyceae',SiteIndexes,outdir);
    StageFromSheetTable(SheetTable,DateStr,171,'Raphidophyceae',SiteIndexes,outdir);
      
end

function StageFromSheetTable(SheetTable,DateStr,ExcelLineNumber,NameInExcel,SiteIndexes,outdir)
    LineNumberInSheetTable = ExcelLineNumber-2;

    for  siteNum = 1:length(SiteIndexes)
        siteIndex = SiteIndexes(siteNum);
        CellConcentration = SheetTable{LineNumberInSheetTable,siteIndex};
        fname = sprintf("%s%s_S%d.csv",outdir,NameInExcel,siteNum);
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