% function Waves51()
    run('../../../actions/csiem_data_paths.m')
    main_dir = [datapath,'data-lake/WAMSI/WWMSP5/WWMSP5_waves/'];
   
    headers = headerstringcreator();
    filecell = RecursiveListDataFilesInDir(main_dir);
    load ../../../actions/sitekey.mat;
    SiteListStruct = sitekey.wwmsp5;

    AllDataTable = table();
    for SiteNum = 1:length(filecell)
        filename = filecell{SiteNum}
        if contains(filename, '._')
            % Skip this file if it starts with dot underline.
            continue;
        end
        SiteString = siteExtractor(filename);
        SiteStruct = SearchSitelistbyStr(SiteListStruct,SiteString);
        RawData = readtable(filename);
        MonthTable = RawData(:,1:16);
        MonthTable.Properties.VariableNames = headers(1:16)';
        MonthTable.Depth = MonthTable.Depth/1000;

        SITEID = strings(height(MonthTable),1);
        SITEID(:) = SiteStruct.ID;
        SITENAME = strings(height(MonthTable),1);
        SITENAME(:) = SiteString;
        LAT = SiteStruct.Lat*ones(height(MonthTable),1);
        LON = SiteStruct.Lon*ones(height(MonthTable),1);
        siteTable = table(SITEID,SITENAME,LAT,LON);

        TempBinTable = table();

        for VerticalIndex = 1:height(MonthTable) 
            NumOfBins = RawData{VerticalIndex,16};
            dz = MonthTable.Depth(VerticalIndex)/NumOfBins;

            DepthVec = zeros(NumOfBins,1);
            MagVec = zeros(NumOfBins,1);
            DirVec = zeros(NumOfBins,1);
            
            for binIndex = 1:NumOfBins

                MagInd = 17+(binIndex-1)*2;
                DirInd = 17+1+(binIndex-1)*2;

                MagVec(binIndex) = RawData{VerticalIndex,MagInd};
                DirVec(binIndex) = RawData{VerticalIndex,DirInd};
                DepthVec(binIndex) = binIndex*dz-0.5*dz;
            
            end
            % disp([MagVec,DirVec,DepthVec]) display to check its correct 

            TempBinTable(VerticalIndex,:) = table({DepthVec},{MagVec},{DirVec});
            
            % break % only one row
        end

        TempBinTable.Properties.VariableNames = {'Velocity Vector Depth','Velocity Vector Magnitude','Velocity Vector Direction'};

        MonthTable = [MonthTable siteTable TempBinTable];
        AllDataTable = [AllDataTable;MonthTable];
        %break%only one site/one month
    end
    AllDataTable;
    save('Test.mat','AllDataTable')
% end

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
        disp(fileSiteStr)
        disp('Onto sites now')
        for StructSiteIndex = 1:NumOfVariables
            disp(SiteListStruct.(SitelistFeilds{StructSiteIndex}).ID)
        end
        stop
        %not a keyword, intentially stop the code because issue has happend
    end
end

function VarStruct = SearchVarlist(VarListStruct,FileVarHeader)
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
        disp(FileVarHeader)
        for StructVarIndex = 1:NumOfVariables
            disp(VarListStruct.(VarlistFeilds{StructVarIndex}).Old)
        end
        stop
        %not a keyword, intentially stop the code because issue has happend
    end

end

function filenameCell = RecursiveListDataFilesInDir(folderpath)
    folderpath = [folderpath,'**/*.TXT'];
    Root = dir(folderpath);
    for i =1:length(Root)
        filenameCell{i} = fullfile(Root(i).folder,Root(i).name);
    end
end

function headers = headerstringcreator()
    raw = 'burst,YY,MM,DD,HH,mm,ss,cc,Hs,Tp,Dp,Depth,H1/10,Tmean,Dmean,#bins,depthlevel1Mag,depthlevel1Direction';
    headers = split(raw,',');
end

function site = siteExtractor(filename)
    site = '';
    temp = split(filename,filesep);
    temp2 = temp{end};
    temp3 = split(temp2,"_");
    site = temp3{1};

    % temp2 = split(filename,"/"){end}
end

function timeStr = TimeConstructor(Table)
    % As of now burst,YY,MM,DD,HH,mm,ss,cc,........
    % YY is 21 so need to append 20 -> 2021
    %This is the format in the header file yyyy-mm-dd HH:MM:SS

    Height = height(Table);
    timeStr = strings(Height,1);
    for i = 1:Height
        timeStr(i) = sprintf("20%2d-%02d-%02d %02d:%02d:%02d",Table.YY(i),Table.MM(i),Table.DD(i),Table.HH(i),Table.mm(i),Table.ss(i));
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