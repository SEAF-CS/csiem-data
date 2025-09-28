% function import_ZooPlankton
    run('../../actions/csiem_data_paths.m')
    filepath = [datapath,'data-lake/WAMSI/WWMSP4/ZooPlankton/zooplankton biovolume mm3_m3 Westport.xlsx'];
    
    outdir = [datapath,'data-warehouse/csv/wamsi/wwmsp4/zooplankton/'];
    
    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../actions/varkey.mat;
    load ../../actions/agency.mat;
    load ../../actions/sitekey.mat;

    VarListStruct = agency.wwmsp4;
    SiteListStruct = sitekey.wwmsp4;

    opts = detectImportOptions(filepath,'sheet','DATA');
    TableOfData = readtable(filepath,opts);
    DateSiteStr = readcell(filepath,'sheet','DATA','Range','F1:GC1');
    SPLITUP = split(DateSiteStr',' ')'; % notice the transposing with ', this is to combat formating.
    DataFileSiteList = SPLITUP(1,:);
    Dates = datetime(TableOfData{2,6:end},'ConvertFrom', 'excel');

    % Determine which Col is which site.
    [UniqueSites,~,IndexesOfUnique] = unique(DataFileSiteList);

    for i = 1:length(UniqueSites)
        UniqueSiteName = UniqueSites{i};
        UniqueSiteSiteKey{i} = SearchSitelistbyID(SiteListStruct,UniqueSiteName);
    end

    for varInd = 4:height(TableOfData) %start of data is at 4
        Varname = TableOfData{varInd,3};
        if isempty(Varname{1})
            continue
        end

        AgencyS = SearchVarlist(VarListStruct,Varname);
        VarS = varkey.(AgencyS.ID);

        for UniqueSiteInd = 1:length(UniqueSites)
            IndexesOfThisSite = find(IndexesOfUnique==UniqueSiteInd) + 6-1; % The plus 6-1 is because the indexes need to be shifted to match the DataTable
            
            for ThisSiteInd = 1:length(IndexesOfThisSite)
                ReadInValue = TableOfData{varInd,IndexesOfThisSite(ThisSiteInd)}*AgencyS.Conv;
                Date = Dates(IndexesOfThisSite(ThisSiteInd)-6+1); %this shift brings it back to the correct starting point.
                Date.Format = 'yyyy-MM-dd HH:mm:ss';
                Depth = 0;
                QC = 'N';
                [fdata,fheader] = filenamecreator(outdir,UniqueSiteSiteKey{UniqueSiteInd},VarS);

                % Check if file exists
                if ~exist(fheader,'file')
                    fid = fopen(fdata,'w');
                    fprintf(fid,"Date,Depth,Data,QC\n");
                    fclose(fid);

                    write_header(fheader,AgencyS.ID,VarS,UniqueSiteSiteKey{UniqueSiteInd});
                    % create header and datafile
                end

                %Append to file
                fid = fopen(fdata,'a');
                fprintf(fid,"%s,%f,%f,%s\n",char(Date),Depth,ReadInValue,QC);
                fclose(fid);
          

                
            end

        end

    end


    


% end

function [data,header] = filenamecreator(outpath,SiteStruct,VarStruct)
    filevar = regexprep(VarStruct.Name,' ','_');
    filesite = SiteStruct.AED;

    base = [outpath,filesite,'_',filevar];
    data = [base,'_DATA.csv'];
    header = [base,'_HEADER.csv'];

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
        disp('Start of DEBUG')
        disp(FileVarHeader)
        for StructVarIndex = 1:NumOfVariables
            disp(['|',VarListStruct.(VarlistFeilds{StructVarIndex}).Old,'|'])
        end
        stop
        %not a keyword, intentially stop the code because issue has happend
    end

end

function SiteStruct = SearchSitelistbyID(SiteListStruct,AEDID)
    neverFound = true;
    SitelistFeilds = fields(SiteListStruct);
    NumOfVariables = length(SitelistFeilds);
   
    for StructSiteIndex = 1:NumOfVariables
                                                 
        if strcmp(AEDID,SiteListStruct.(SitelistFeilds{StructSiteIndex}).ID)
            SiteStruct = SiteListStruct.(SitelistFeilds{StructSiteIndex});
            neverFound = false;
            break
        end

    end
    if neverFound == true
        disp('DataFile site:');
        disp(AEDID)
        disp('Sitekey list:');
        for StructSiteIndex = 1:NumOfVariables
            disp(SiteListStruct.(SitelistFeilds{StructSiteIndex}).AED);                 
        end
        stop
        %not a keyword, intentially stop the code because issue has happend
    end
end