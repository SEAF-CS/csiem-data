function import_phytoplankton2_Group()

    run('../../../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-lake/WCWA/PLOOM/Phyto/2/'];
    outdir = [datapath,'data-warehouse/csv/wcwa/ploom/phy/group/2/'];



    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../../../actions/varkey.mat;
    load ../../../../actions/agency.mat;
    load ../../../../actions/sitekey.mat;

    VarListStruct = agency.WCWA2_PhytoplanktonGroup;
    SiteListStruct = sitekey.WCWA2Phyto;
    varnameInsideAgencyStruct = fieldnames(VarListStruct);

    unimprtedFID = fopen("UnimportedGroup.txt","w");


    filecell = RecursiveListDataFilesInDir(main_dir);
    for fileNum = 1:length(filecell)
        filename = filecell{fileNum};
        if contains(filename, '._')
            % Skip this file if it starts with dot underline.
            continue;
        end

        T = ReadinDataFile(filename);
        [Sites,Dates] = ReadInMetadatafile(filename);
        
        % matlab is Col major hence iterate over cols first
        if width(T) ~= 228
            disp('data has changed since writing')
            stop
        end


        %% for speed finding all variable id's at the start
        varIds = cell(height(T),1);
        AgencyIndexs = nan(height(T),1);
        for rowNum = 1:height(T)
            % match to varkey
            varname =  T.("Taxon")(rowNum); % col 2
            [AgencyStruct,AgencyIndex] = SearchVarlist(VarListStruct,varname);
            if AgencyIndex == 0 
                fprintf(unimprtedFID,"%s\n",varname{1});
                varIds{rowNum} = '0';
                AgencyIndexs(rowNum) = 0;
                %% this is used to skip groups in the species code
                continue
            end
            varIds{rowNum} = AgencyStruct.ID;
            AgencyIndexs(rowNum) = AgencyIndex;
            
        end


        dataindexVec = [5:2:228];
        NumofSites = length(dataindexVec);%%(228-4)/2; % 228 cells, first data point is 5 , and there 2 cells for every site.
        for SiteNum = 1:NumofSites
            SiteName = Sites{SiteNum};
            % This sitename looks like WC1S with an S or B on the end, meaning surface or bottom,
            % the values are taken 0.5m from respective boundary.
            SiteStruct = SearchSitelistbyStr(SiteListStruct,SiteName);
            if SiteName(end) == "S"
                Deployment = 'Floating';
                heightOrdepth = 'Depth';
                VerticalRef = 'm below surface';

            elseif SiteName(end) == "B"
                Deployment = 'Fixed';
                heightOrdepth = 'Height';
                VerticalRef = 'm above seafloor';

            else
                error("Not Correct on site")
            end
            
            dataindex = dataindexVec(SiteNum);
            Date = Dates(SiteNum);
            DateTimeObj = datetime(Date,'InputFormat','dd-MMM-yy');
            DateTimeObj.Format='yyyy-MM-dd HH:mm:ss';
            DateStr = string(DateTimeObj);
            
            for rowNum = 1:height(T)
                % match to varkey
                if AgencyIndexs(rowNum) == 0
                    continue
                    % This is because of group
                end

                varId = varIds{rowNum};
                VarStruct = varkey.(varId);
                Conv = VarListStruct.(varnameInsideAgencyStruct{AgencyIndexs(rowNum)}).Conv; 
                Depth = 0.5;
                DataVal = T{rowNum,dataindex}*Conv; % "Count"
                if isnan(DataVal)
                    continue    
                end

                Date;

                [fDATA,fHEADER] = filenamecreator(outdir,SiteStruct,VarStruct);


                if ~exist(fDATA,'file')
                    %only gets in here when file doesnt exist already
                    fid = fopen(fDATA,'W');
                    fprintf(fid,"Date,%s,Data,QC\n",heightOrdepth);
                    fclose(fid);

                    temp = split(fDATA,filesep);
                    filename_short = temp{end};
                    fid = fopen(fHEADER,'w');
                        fprintf(fid,'Agency Name,Water Corporation WA\n');
                        
                        fprintf(fid,'Agency Code,WCWA\n');
                        fprintf(fid,'Program,WCWA2 Phytoplankton\n');
                        fprintf(fid,'Project,WCWA2 Phytoplankton\n');
                        fprintf(fid,'Tag,WCWA2_Phytoplankton_Group\n');
    
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
                        fprintf(fid,'Deployment Position,%s\n',['0.0',VerticalRef]); % '0.0m above Seabed' 0m below surface);
                        fprintf(fid,'Vertical Reference,%s\n',VerticalRef);
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
                    fprintf(fid,"%s,%f,%f,N\n",DateStr,Depth,DataVal);
                fclose(fid);
            
            end


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

function    CSDOMaster20060824 = ReadinDataFile(filename)
    % Auto-generated by MATLAB on 13-Aug-2024 13:21:10

            %% Set up the Import Options and import the data
            opts = spreadsheetImportOptions("NumVariables", 228);

            % Specify sheet and range
            opts.Sheet = " Sheet 1";
            opts.DataRange = "A26:HT774";

            % Specify column names and types
            opts.VariableNames = ["VarName1", "Taxon", "District", "VarName4", "WC1S", "VarName6", "WC1B", "VarName8", "WC2S", "VarName10", "WC2B", "VarName12", "WC3S", "VarName14", "WC3B", "VarName16", "WC4S", "VarName18", "WC4B", "VarName20", "WC5S", "VarName22", "WC5B", "VarName24", "WC6S", "VarName26", "WC6B", "VarName28", "WC7S", "VarName30", "WC7B", "VarName32", "WC8S", "VarName34", "WC8B", "VarName36", "WC1S1", "VarName38", "WC1B1", "VarName40", "WC2S1", "VarName42", "WC2B1", "VarName44", "WC3S1", "VarName46", "WC3B1", "VarName48", "WC4S1", "VarName50", "WC4B1", "VarName52", "WC5S1", "VarName54", "WC5B1", "VarName56", "WC6S1", "VarName58", "WC6B1", "VarName60", "WC7S1", "VarName62", "WC7B1", "VarName64", "WC8S1", "VarName66", "WC8B1", "VarName68", "WC1S2", "VarName70", "WC1B2", "VarName72", "WC2S2", "VarName74", "WC2B2", "VarName76", "WC3S2", "VarName78", "WC3B2", "VarName80", "WC4S2", "VarName82", "WC4B2", "VarName84", "WC5S2", "VarName86", "WC5B2", "VarName88", "WC6S2", "VarName90", "WC6B2", "VarName92", "WC7S2", "VarName94", "WC7B2", "VarName96", "WC8S2", "VarName98", "WC8B2", "VarName100", "WC1S3", "VarName102", "WC1B3", "VarName104", "WC2S3", "VarName106", "WC2B3", "VarName108", "WC3S3", "VarName110", "WC3B3", "VarName112", "WC4S3", "VarName114", "WC4B3", "VarName116", "WC5S3", "VarName118", "WC5B3", "VarName120", "WC6S3", "VarName122", "WC6B3", "VarName124", "WC7S3", "VarName126", "WC7B3", "VarName128", "WC8S3", "VarName130", "WC8B3", "VarName132", "WC1S4", "VarName134", "WC1B4", "VarName136", "WC2S4", "VarName138", "WC2B4", "VarName140", "WC3S4", "VarName142", "WC3B4", "VarName144", "WC4S4", "VarName146", "WC4B4", "VarName148", "WC5S4", "VarName150", "WC5B4", "VarName152", "WC6S4", "VarName154", "WC6B4", "VarName156", "WC7S4", "VarName158", "WC7B4", "VarName160", "WC8S4", "VarName162", "WC8B4", "VarName164", "WC1S5", "VarName166", "WC1B5", "VarName168", "WC2S5", "VarName170", "WC2B5", "VarName172", "WC3S5", "VarName174", "WC3B5", "VarName176", "WC4S5", "VarName178", "WC4B5", "VarName180", "WC5S5", "VarName182", "WC5B5", "VarName184", "WC6S5", "VarName186", "WC6B5", "VarName188", "WC7S5", "VarName190", "WC7B5", "VarName192", "WC8S5", "VarName194", "WC8S6", "VarName196", "WC1S6", "VarName198", "WC1B6", "VarName200", "WC2S6", "VarName202", "WC2B6", "VarName204", "WC3S6", "VarName206", "WC3B6", "VarName208", "WC4S6", "VarName210", "WC4B6", "VarName212", "WC5S6", "VarName214", "WC5B6", "VarName216", "WC6S6", "VarName218", "WC6B6", "VarName220", "WC7S6", "VarName222", "WC7B6", "VarName224", "WC8S7", "VarName226", "WC8B5", "VarName228"];
            opts.VariableTypes = ["char", "char", "char", "char", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

            % Specify variable properties
            opts = setvaropts(opts, ["VarName1", "Taxon", "District", "VarName4"], "WhitespaceRule", "preserve");
            opts = setvaropts(opts, ["VarName1", "Taxon", "District", "VarName4"], "EmptyFieldRule", "auto");

            % Import the data
            CSDOMaster20060824 = readtable(filename, opts, "UseExcel", false);
end

function [Sites,Dates] = ReadInMetadatafile(filename) 
    %% Set up the Import Options and import the data
    opts = spreadsheetImportOptions("NumVariables", 224);

    % Specify sheet
    opts.Sheet = " Sheet 1";

    % Specify column names and types
    opts.VariableNames = ["WC1S", "VarName6", "WC1B", "VarName8", "WC2S", "VarName10", "WC2B", "VarName12", "WC3S", "VarName14", "WC3B", "VarName16", "WC4S", "VarName18", "WC4B", "VarName20", "WC5S", "VarName22", "WC5B", "VarName24", "WC6S", "VarName26", "WC6B", "VarName28", "WC7S", "VarName30", "WC7B", "VarName32", "WC8S", "VarName34", "WC8B", "VarName36", "WC1S_1", "VarName38", "WC1B_1", "VarName40", "WC2S_1", "VarName42", "WC2B_1", "VarName44", "WC3S_1", "VarName46", "WC3B_1", "VarName48", "WC4S_1", "VarName50", "WC4B_1", "VarName52", "WC5S_1", "VarName54", "WC5B_1", "VarName56", "WC6S_1", "VarName58", "WC6B_1", "VarName60", "WC7S_1", "VarName62", "WC7B_1", "VarName64", "WC8S_1", "VarName66", "WC8B_1", "VarName68", "WC1S_2", "VarName70", "WC1B_2", "VarName72", "WC2S_2", "VarName74", "WC2B_2", "VarName76", "WC3S_2", "VarName78", "WC3B_2", "VarName80", "WC4S_2", "VarName82", "WC4B_2", "VarName84", "WC5S_2", "VarName86", "WC5B_2", "VarName88", "WC6S_2", "VarName90", "WC6B_2", "VarName92", "WC7S_2", "VarName94", "WC7B_2", "VarName96", "WC8S_2", "VarName98", "WC8B_2", "VarName100", "WC1S_3", "VarName102", "WC1B_3", "VarName104", "WC2S_3", "VarName106", "WC2B_3", "VarName108", "WC3S_3", "VarName110", "WC3B_3", "VarName112", "WC4S_3", "VarName114", "WC4B_3", "VarName116", "WC5S_3", "VarName118", "WC5B_3", "VarName120", "WC6S_3", "VarName122", "WC6B_3", "VarName124", "WC7S_3", "VarName126", "WC7B_3", "VarName128", "WC8S_3", "VarName130", "WC8B_3", "VarName132", "WC1S_4", "VarName134", "WC1B_4", "VarName136", "WC2S_4", "VarName138", "WC2B_4", "VarName140", "WC3S_4", "VarName142", "WC3B_4", "VarName144", "WC4S_4", "VarName146", "WC4B_4", "VarName148", "WC5S_4", "VarName150", "WC5B_4", "VarName152", "WC6S_4", "VarName154", "WC6B_4", "VarName156", "WC7S_4", "VarName158", "WC7B_4", "VarName160", "WC8S_4", "VarName162", "WC8B_4", "VarName164", "WC1S_5", "VarName166", "WC1B_5", "VarName168", "WC2S_5", "VarName170", "WC2B_5", "VarName172", "WC3S_5", "VarName174", "WC3B_5", "VarName176", "WC4S_5", "VarName178", "WC4B_5", "VarName180", "WC5S_5", "VarName182", "WC5B_5", "VarName184", "WC6S_5", "VarName186", "WC6B_5", "VarName188", "WC7S_5", "VarName190", "WC7B_5", "VarName192", "WC8S_5", "VarName194", "WC8S_6", "VarName196", "WC1S_6", "VarName198", "WC1B_6", "VarName200", "WC2S_6", "VarName202", "WC2B_6", "VarName204", "WC3S_6", "VarName206", "WC3B_6", "VarName208", "WC4S_6", "VarName210", "WC4B_6", "VarName212", "WC5S_6", "VarName214", "WC5B_6", "VarName216", "WC6S_6", "VarName218", "WC6B_6", "VarName220", "WC7S_6", "VarName222", "WC7B_6", "VarName224", "WC8S_7", "VarName226", "WC8B_5", "VarName228"];
    opts.VariableTypes = ["char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char"];

    % Specify variable properties
    opts = setvaropts(opts, ["WC1S", "VarName6", "WC1B", "VarName8", "WC2S", "VarName10", "WC2B", "VarName12", "WC3S", "VarName14", "WC3B", "VarName16", "WC4S", "VarName18", "WC4B", "VarName20", "WC5S", "VarName22", "WC5B", "VarName24", "WC6S", "VarName26", "WC6B", "VarName28", "WC7S", "VarName30", "WC7B", "VarName32", "WC8S", "VarName34", "WC8B", "VarName36", "WC1S_1", "VarName38", "WC1B_1", "VarName40", "WC2S_1", "VarName42", "WC2B_1", "VarName44", "WC3S_1", "VarName46", "WC3B_1", "VarName48", "WC4S_1", "VarName50", "WC4B_1", "VarName52", "WC5S_1", "VarName54", "WC5B_1", "VarName56", "WC6S_1", "VarName58", "WC6B_1", "VarName60", "WC7S_1", "VarName62", "WC7B_1", "VarName64", "WC8S_1", "VarName66", "WC8B_1", "VarName68", "WC1S_2", "VarName70", "WC1B_2", "VarName72", "WC2S_2", "VarName74", "WC2B_2", "VarName76", "WC3S_2", "VarName78", "WC3B_2", "VarName80", "WC4S_2", "VarName82", "WC4B_2", "VarName84", "WC5S_2", "VarName86", "WC5B_2", "VarName88", "WC6S_2", "VarName90", "WC6B_2", "VarName92", "WC7S_2", "VarName94", "WC7B_2", "VarName96", "WC8S_2", "VarName98", "WC8B_2", "VarName100", "WC1S_3", "VarName102", "WC1B_3", "VarName104", "WC2S_3", "VarName106", "WC2B_3", "VarName108", "WC3S_3", "VarName110", "WC3B_3", "VarName112", "WC4S_3", "VarName114", "WC4B_3", "VarName116", "WC5S_3", "VarName118", "WC5B_3", "VarName120", "WC6S_3", "VarName122", "WC6B_3", "VarName124", "WC7S_3", "VarName126", "WC7B_3", "VarName128", "WC8S_3", "VarName130", "WC8B_3", "VarName132", "WC1S_4", "VarName134", "WC1B_4", "VarName136", "WC2S_4", "VarName138", "WC2B_4", "VarName140", "WC3S_4", "VarName142", "WC3B_4", "VarName144", "WC4S_4", "VarName146", "WC4B_4", "VarName148", "WC5S_4", "VarName150", "WC5B_4", "VarName152", "WC6S_4", "VarName154", "WC6B_4", "VarName156", "WC7S_4", "VarName158", "WC7B_4", "VarName160", "WC8S_4", "VarName162", "WC8B_4", "VarName164", "WC1S_5", "VarName166", "WC1B_5", "VarName168", "WC2S_5", "VarName170", "WC2B_5", "VarName172", "WC3S_5", "VarName174", "WC3B_5", "VarName176", "WC4S_5", "VarName178", "WC4B_5", "VarName180", "WC5S_5", "VarName182", "WC5B_5", "VarName184", "WC6S_5", "VarName186", "WC6B_5", "VarName188", "WC7S_5", "VarName190", "WC7B_5", "VarName192", "WC8S_5", "VarName194", "WC8S_6", "VarName196", "WC1S_6", "VarName198", "WC1B_6", "VarName200", "WC2S_6", "VarName202", "WC2B_6", "VarName204", "WC3S_6", "VarName206", "WC3B_6", "VarName208", "WC4S_6", "VarName210", "WC4B_6", "VarName212", "WC5S_6", "VarName214", "WC5B_6", "VarName216", "WC6S_6", "VarName218", "WC6B_6", "VarName220", "WC7S_6", "VarName222", "WC7B_6", "VarName224", "WC8S_7", "VarName226", "WC8B_5", "VarName228"], "WhitespaceRule", "preserve");
    opts = setvaropts(opts, ["WC1S", "VarName6", "WC1B", "VarName8", "WC2S", "VarName10", "WC2B", "VarName12", "WC3S", "VarName14", "WC3B", "VarName16", "WC4S", "VarName18", "WC4B", "VarName20", "WC5S", "VarName22", "WC5B", "VarName24", "WC6S", "VarName26", "WC6B", "VarName28", "WC7S", "VarName30", "WC7B", "VarName32", "WC8S", "VarName34", "WC8B", "VarName36", "WC1S_1", "VarName38", "WC1B_1", "VarName40", "WC2S_1", "VarName42", "WC2B_1", "VarName44", "WC3S_1", "VarName46", "WC3B_1", "VarName48", "WC4S_1", "VarName50", "WC4B_1", "VarName52", "WC5S_1", "VarName54", "WC5B_1", "VarName56", "WC6S_1", "VarName58", "WC6B_1", "VarName60", "WC7S_1", "VarName62", "WC7B_1", "VarName64", "WC8S_1", "VarName66", "WC8B_1", "VarName68", "WC1S_2", "VarName70", "WC1B_2", "VarName72", "WC2S_2", "VarName74", "WC2B_2", "VarName76", "WC3S_2", "VarName78", "WC3B_2", "VarName80", "WC4S_2", "VarName82", "WC4B_2", "VarName84", "WC5S_2", "VarName86", "WC5B_2", "VarName88", "WC6S_2", "VarName90", "WC6B_2", "VarName92", "WC7S_2", "VarName94", "WC7B_2", "VarName96", "WC8S_2", "VarName98", "WC8B_2", "VarName100", "WC1S_3", "VarName102", "WC1B_3", "VarName104", "WC2S_3", "VarName106", "WC2B_3", "VarName108", "WC3S_3", "VarName110", "WC3B_3", "VarName112", "WC4S_3", "VarName114", "WC4B_3", "VarName116", "WC5S_3", "VarName118", "WC5B_3", "VarName120", "WC6S_3", "VarName122", "WC6B_3", "VarName124", "WC7S_3", "VarName126", "WC7B_3", "VarName128", "WC8S_3", "VarName130", "WC8B_3", "VarName132", "WC1S_4", "VarName134", "WC1B_4", "VarName136", "WC2S_4", "VarName138", "WC2B_4", "VarName140", "WC3S_4", "VarName142", "WC3B_4", "VarName144", "WC4S_4", "VarName146", "WC4B_4", "VarName148", "WC5S_4", "VarName150", "WC5B_4", "VarName152", "WC6S_4", "VarName154", "WC6B_4", "VarName156", "WC7S_4", "VarName158", "WC7B_4", "VarName160", "WC8S_4", "VarName162", "WC8B_4", "VarName164", "WC1S_5", "VarName166", "WC1B_5", "VarName168", "WC2S_5", "VarName170", "WC2B_5", "VarName172", "WC3S_5", "VarName174", "WC3B_5", "VarName176", "WC4S_5", "VarName178", "WC4B_5", "VarName180", "WC5S_5", "VarName182", "WC5B_5", "VarName184", "WC6S_5", "VarName186", "WC6B_5", "VarName188", "WC7S_5", "VarName190", "WC7B_5", "VarName192", "WC8S_5", "VarName194", "WC8S_6", "VarName196", "WC1S_6", "VarName198", "WC1B_6", "VarName200", "WC2S_6", "VarName202", "WC2B_6", "VarName204", "WC3S_6", "VarName206", "WC3B_6", "VarName208", "WC4S_6", "VarName210", "WC4B_6", "VarName212", "WC5S_6", "VarName214", "WC5B_6", "VarName216", "WC6S_6", "VarName218", "WC6B_6", "VarName220", "WC7S_6", "VarName222", "WC7B_6", "VarName224", "WC8S_7", "VarName226", "WC8B_5", "VarName228"], "EmptyFieldRule", "auto");

    % Import the data
    CSDOMaster1 = table;
    ranges = ["E11:HT11", "E15:HT15"];
    for idx = 1:length(ranges)
        opts.DataRange = ranges(idx);
        tb = readtable(filename, opts, "UseExcel", false);
        CSDOMaster1 = [CSDOMaster1; tb]; %#ok<AGROW>
    end

    %% Convert to output type
    CSDOMaster1 = table2cell(CSDOMaster1);
    numIdx = cellfun(@(x) ~isnan(str2double(x)), CSDOMaster1);
    CSDOMaster1(numIdx) = cellfun(@(x) {str2double(x)}, CSDOMaster1(numIdx));

    Sites = CSDOMaster1(1,[1:2:end]);
    Dates = CSDOMaster1(2,[1:2:end]);
end