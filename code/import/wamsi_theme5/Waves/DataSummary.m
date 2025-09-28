% function Waves51()
    run('../../../actions/csiem_data_paths.m')
    main_dir = [datapath,'data-lake/WAMSI/wwmsp5.1_waves/'];
    headers = headerstringcreator();
    filecell = RecursiveListDataFilesInDir('/GIS_DATA/csiem-data-hub/data-lake/WAMSI/wwmsp5.1_waves/');

    AllDataTable = table();
    for SiteNum = 1:length(filecell)
        filename = filecell{SiteNum};
        if contains(filename, '._')
            % Skip this file if it starts with dot underline.
            continue;
        end
        SiteString = siteExtractor(filename);

        RawData = readtable(filename);
        MonthTable = RawData(:,1:16);
        MonthTable.Properties.VariableNames = headers(1:16)';
        start = TimeConstructor(MonthTable(1,:));
        finish = TimeConstructor(MonthTable(end,:));

        fprintf("%s\n    %s->%s\n    %s\n\n",SiteString,start,finish,filename)
    end 
        
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
    temp = split(filename,"/");
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
    filevar = regexprep(filevar,'\/','.');
    filesite = SiteStruct.AED;

    base = [outpath,filesite,'_',filevar];
    data = [base,'_DATA.csv'];
    header = [base,'_HEADER.csv'];

end