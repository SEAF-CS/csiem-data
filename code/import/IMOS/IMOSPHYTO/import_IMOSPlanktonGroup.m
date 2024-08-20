function import_IMOSPlanktonGroup()

    run('../../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-warehouse/csv_holding/imos/PhytoPlanktonGroup/'];
    outdir = [datapath,'data-warehouse/csv/imos/PhytoPlanktonGroup/'];



    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../../actions/varkey.mat;
    load ../../../actions/agency.mat;
    load ../../../actions/sitekey.mat;
  

    VarListStruct = agency.IMOS_PhytoplanktonGroup;
    SiteListStruct = sitekey.IMOS_Phytoplankton;

    filecell = RecursiveListDataFilesInDir(main_dir);
    for SiteNum = 1:length(filecell)
        filename = filecell{SiteNum};
        opts = detectImportOptions(filename);
        T = readtable(filename,opts);
        [Dates,~,IDates] = unique(T.Date);
        
        fid = fopen(filename,'w');
        fprintf(fid,"Date,Depth,Data,QC\n");

        for DateNum = 1:length(Dates)
            ThisDateIndexes = IDates==DateNum;
            CellsPermL = sum(T.Data(ThisDateIndexes));
            Depth = mean(T.Depth(ThisDateIndexes));
            fprintf(fid,"%s,%f,%f,N\n",Dates(DateNum),Depth,CellsPermL);
        end
        fclose(fid);
        % break;
        % This break is so that I only do one file
    end
    movefile(main_dir,[outdir,'../'],'f')
         % break;
        % This break is so that I only do one site
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

function [VarStruct,neverFound] = SearchVarlist(VarListStruct,FileVarHeader)
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
        VarStruct = 0;
        % for StructVarIndex = 1:NumOfVariables
        %     disp(VarListStruct.(VarlistFeilds{StructVarIndex}).Old)
        % end
        % stop
        %not a keyword, intentially stop the code because issue has happend
    end

end

function filenameCell = RecursiveListDataFilesInDir(folderpath)
    folderpath = [folderpath,'**/*_DATA.csv'];
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