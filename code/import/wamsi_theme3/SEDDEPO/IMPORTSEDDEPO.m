function IMPORTSEDDEPO()
    load ../../../actions/varkey.mat;
    load ../../../actions/agency.mat;
    load ../../../actions/sitekey.mat;

    VarListStruct = agency.wwmsp3;
    SiteListStruct = sitekey.WWMSP31SedimentDeposition;

    run('../../../actions/csiem_data_paths.m')
    outdir = [datapath,'data-warehouse/csv/wamsi/wwmsp3/seddep/'];
    mkdir(outdir);


    
    dataDir = [datapath,'data-lake/WAMSI/WWMSP3/WWMSP3.1_SEDDEPO/Sediment Deposition Logger Data/'];
    % data path was updated on 2024-06-10
   

    filelist = dir(fullfile(dataDir,'*.csv'));
    #Filter to not use the data that has ._ in the front of the file name, these are macOS temp files
    filelist = filelist(arrayfun(@(x) ~startsWith(x.name, '._'), filelist)); # keep only files that do not start with '._'  
    for fileIndex = 1:length(filelist)
       datafilename = fullfile(dataDir,filelist(fileIndex).name);
       disp(['Processing file: ',filelist(fileIndex).name])

        parts = split(filelist(fileIndex).name,'_');
        sitename = parts{2};

        AEDID = ['site',sitename];

        SiteStruct = SearchSitelistbyAEDID(SiteListStruct,AEDID);
        if isempty(SiteStruct)
            continue
        end

        warning('off','MATLAB:table:ModifiedAndSavedVarnames')
        DataFilesTable = readtable(datafilename,"TreatAsMissing","NA");
        warning('on','MATLAB:table:ModifiedAndSavedVarnames')
        Vars = DataFilesTable.Properties.VariableDescriptions';

        DateVec = DataFilesTable{:,3};
        DepthVec = DataFilesTable{:,9};
        try
            DateDT = datetime(DateVec,'InputFormat','MM-dd-yyyy HH:mm:ss');
        catch
            DateDT = datetime(DateVec,'InputFormat','MM-dd-yyyy HH:mm');
        end
        DateDT.Format = 'yyyy-MM-dd HH:mm:ss';
        DateString = cellstr(DateDT);
            
            % Skipping Date col
            for varIndex = 2:length(Vars)

                % displays current varibale name and how big it is (uses date)
                disp(['     Processing Variable ' Vars{varIndex} ' ' num2str(length(DateVec)) 'x1']);
    
                %workout what variable we are dealing with
                AgencyStruct = SearchVarlist(VarListStruct,Vars,varIndex);

                    if isempty(AgencyStruct)
                          continue
                 end
    
                if strcmp(AgencyStruct.ID,'var00')
                    disp(['         ',Vars{varIndex}, 'is being skipped']);
                    continue
                end

                VarStruct = varkey.(AgencyStruct.ID);
                [fnameData,fnameHeader] = filenamecreator(outdir,SiteStruct,VarStruct);
    
                        
    
                fid = fopen(fnameData,'W');
                fprintf(fid,'Date,Depth,Data,QC\n');
                DataVec = DataFilesTable{:,varIndex}*AgencyStruct.Conv;
                
    
    
    
                for nn = 1:length(DataVec)
                    if isnan(DataVec(nn))
                        continue
                    end
    
                    QC = 'N';
                    fprintf(fid,'%s,%4.4f,%4.4f,%s\n',DateString{nn},DepthVec(nn),DataVec(nn),QC);
                end
                fclose(fid);
    
                
                lat = SiteStruct.Lat;
                lon = SiteStruct.Lon;
                ID = SiteStruct.ID;
                Desc = SiteStruct.Description;
    
    
                varID = AgencyStruct.ID;
                Cat = VarStruct.Category;
                varstring = VarStruct.Name;
    
                wdate = '';
                sitedepth = '';
                %%bad code practise by copied from
                %csiem-data-hub/git/code/import/wamsi_theme3/SEDPSD/Functions/write_header
                write_header(fnameHeader,lat,lon,ID,Desc,varID,Cat,varstring,wdate,sitedepth)
    
            end
        end
    end
    



function VarStruct = SearchVarlist(VarListStruct,FileHeaders,varIndex)
    neverFound = true;
    VarlistFeilds = fields(VarListStruct);
    NumOfVariables = length(VarlistFeilds);

    FileVarHeader = FileHeaders{varIndex};

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
        disp([FileHeaders{varIndex}, ' not found in var-key; skipping column']);
        VarStruct = [];
        return
    end

end

function SiteStruct = SearchSitelistbyAEDID(SiteListStruct,AEDID)
    neverFound = true;
    SitelistFeilds = fields(SiteListStruct);
    NumOfVariables = length(SitelistFeilds);
   
    for StructSiteIndex = 1:NumOfVariables
                                                 
        if strcmp(AEDID,SiteListStruct.(SitelistFeilds{StructSiteIndex}).AED)
            SiteStruct = SiteListStruct.(SitelistFeilds{StructSiteIndex});
            neverFound = false;
            break
        end

    end
    if neverFound == true
        warning('Site %s not found in site-key; file will be skipped.', AEDID);
        SiteStruct = [];
        return
    end
end

function [data,header] = filenamecreator(outpath,SiteStruct,VarStruct)
    filevar = regexprep(VarStruct.Name,' ','_');
    filesite = SiteStruct.AED;

    base = [outpath,filesite,'_',filevar];
    data = [base,'_DATA.csv'];
    header = [base,'_HEADER.csv'];

end





