clear 
addpath('Functions')
directory = "/Projects2/csiem-data-hub/data-swamp/WWMSP3.1 - Sediment Quality CutDown/Lab_Data";

searchReq = '*PSD*.xlsx';
Sediment = Extractor(directory,searchReq);


VarkeyAddress = "/Projects2/csiem-data-hub/git/data-governance/variable_key.xlsx";
            opts = spreadsheetImportOptions("NumVariables", 2);
            opts.Sheet = "MASTER KEY";
            opts.VariableTypes = ["string", "string"];
            opts.DataRange = "A345:B357";
VarKey = readtable(VarkeyAddress,opts);

FFName = "/Projects2/csiem-data-hub/data-lake/WAMSI/wwmsp3.1_SEDPSD/FlatFile.csv";
FFHeadings = ["Date","X","Y","Site","SampleID","Variable","Units","ReadingValue","VariableName","VariableType","Origin","Filename"];
writematrix(FFHeadings,FFName)
FillFlatFile(FFName,Sediment,"Sediment");


HeaderCSV(FFName,VarKey);


clear directory searchReq
