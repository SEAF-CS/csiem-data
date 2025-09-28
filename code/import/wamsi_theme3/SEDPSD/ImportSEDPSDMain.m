function ImportSEDPSDMain()
    addpath('Functions')
    run('../../../actions/csiem_data_paths.m')

    %% Code for creating the flat file
    % directory = [datapath,'data-swamp/WWMSP3.1 - Sediment Quality CutDown/Lab_Data'];

    % searchReq = '*PSD*.xlsx';
    % Sediment = Extractor(directory,searchReq);
    % Sediment = SedimentLatFixer(Sediment);


    %         %% this chunk has been updated to use the agency.mat 
    %         % VarkeyAddress = "../../../../../git/data-governance/variable_key.xlsx";
    %         %             opts = spreadsheetImportOptions("NumVariables", 2);
    %         %             opts.Sheet = "MASTER KEY";
    %         %             opts.VariableTypes = ["string", "string"];
    %         %             opts.DataRange = "A346:B358"; % works as of 03/04/2024
    %         % VarKey = readtable(VarkeyAddress,opts);
    

    FFName = [datapath,'data-lake/WAMSI/WWMSP3/WWMSP3.1_SEDPSD/FlatFile.csv'];
    % FFHeadings = ["Date","X","Y","Site","SampleID","Variable","Units","ReadingValue","VariableName","VariableType","Origin","Filename"];
    % writematrix(FFHeadings,FFName)
    % FillFlatFile(FFName,Sediment,"Sediment");

    load ../../../actions/varkey.mat;
    load ../../../actions/agency.mat;
    %load ../../../actions/sitekey.mat;

    variableStruct = agency.wwmsp3;

    VarKey = agencyMat2LachyVarkKey(variableStruct);
    % error('deez')


    HeaderCSV(FFName,VarKey,varkey);
end


function VarKey = agencyMat2LachyVarkKey(CurrentAgencyStruct)
    feildList = fields(CurrentAgencyStruct);

    VarKey = table();
    for i = 1:length(feildList)
        header = string(CurrentAgencyStruct.(feildList{i}).Old);
        id = string(CurrentAgencyStruct.(feildList{i}).ID);
        VarKey = [VarKey;table(id,header)];
    end
end

