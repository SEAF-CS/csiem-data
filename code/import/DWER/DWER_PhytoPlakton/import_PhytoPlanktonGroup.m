function import_PhytoPlanktonGroup()

    run('../../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-warehouse/csv_holding/dwer_PhytoplanktonGroups/'];
    outdir = [datapath,'data-warehouse/csv/dwer/dwer_PhytoplanktonGroups/'];

    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    filecell = RecursiveListDataFilesInDir(main_dir);
    for filenum = 1:length(filecell)
        filename = filecell{filenum};
        T = readtable(filename);
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
  
end

function filenameCell = RecursiveListDataFilesInDir(folderpath)
    folderpath = [folderpath,'**/*_DATA.csv'];
    Root = dir(folderpath);
    for i =1:length(Root)
        filenameCell{i} = fullfile(Root(i).folder,Root(i).name);
    end
end

