function SWANESTGroupsStaged()

    run('../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-warehouse/csv_holding/dwer/swanest/phy/group/'];
    outdir = [datapath,'data-warehouse/csv/dwer/swanest/phy/group/'];



    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    filecell = RecursiveListDataFilesInDir(main_dir);
    for filenum = 1:length(filecell)
        filename = filecell{filenum}
        if contains(filename, '._')
            % Skip this file if it starts with dot underline.
            continue;
        end
        opts = detectImportOptions(filename);
        T = readtable(filename,opts);
        [Dates,~,IDates] = unique(T.Date);
        
        fid = fopen(filename,'w');
        fprintf(fid,"Date,Depth,Data,QC\n");

        for DateNum = 1:length(Dates)
            ThisDateIndexes = IDates==DateNum;
            CellsPermL = sum(T.Data(ThisDateIndexes));
            DepthVec = sscanf(sprintf('@%s@',T.Depth{ThisDateIndexes}),"@0-%f@",[1,Inf]);
            MeanDepth = mean(DepthVec);
            fprintf(fid,"%s,0-%.2f,%f,N\n",Dates(DateNum),MeanDepth,CellsPermL);
        end
        fclose(fid);



        % break;
        % This break is so that I only do one file
    end
    movefile(main_dir,[outdir,'../'],'f')
         % break;
        % This break is so that I only do one site
end


function filenameCell = RecursiveListDataFilesInDir(folderpath)
    folderpath = [folderpath,'**/*_DATA.csv'];
    Root = dir(folderpath);
    for i =1:length(Root)
        filenameCell{i} = fullfile(Root(i).folder,Root(i).name);
    end
end