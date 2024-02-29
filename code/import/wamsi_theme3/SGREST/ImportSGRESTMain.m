clear 
addpath('Functions\')
% directory = "WWMSP3.1 - Sediment Quality\SEDIMENT\WWMSP3.1_Baseline_Sediment_Quality_Survey_Lab_Data\Lab_Data";
% searchReq = '*PSD*.xlsx';
% Sediment = Extractor(directory,searchReq);

directory = "WWMSP3.1 - Seagrass/WAMS23-6 WCP3.1  PSD/";
searchReq = '*.xlsx' ;
Seagrass = Extractor(directory,searchReq);

VarkeyAddress = "..\csiem-data\data-governance\variable_key.xlsx";
            opts = spreadsheetImportOptions("NumVariables", 2);
            opts.Sheet = "MASTER KEY";
            opts.VariableTypes = ["string", "string"];
            opts.DataRange = "A345:B357";
VarKey = readtable(VarkeyAddress,opts);

FFName = 'FlatFile.csv';
FFHeadings = ["Date","X","Y","Site","SampleID","Variable","Units","ReadingValue","VariableName","VariableType","Origin","Filename"];
writematrix(FFHeadings,FFName)
FillFlatFile(FFName,Seagrass,"Seagrass");
%FillFlatFile(FFName,Sediment,"Sediment");


HeaderCSV(FFName,VarKey);


clear directory searchReq
