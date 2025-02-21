function import_phytoplankton_Group_Staged()

    run('../../../../actions/csiem_data_paths.m')
    
    main_dir = [datapath,'data-warehouse/csv_holding/wcwa/ploom/phy/group/32/'];
    outdir = [datapath,'data-warehouse/csv/wcwa/ploom/phy/group/32/'];

    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../../../actions/varkey.mat;
    load ../../../../actions/agency.mat;
    load ../../../../actions/sitekey.mat;

    VarListStruct = agency.WCWA32_PhytoplanktonGroup;
    SiteListStruct = sitekey.wc;


    filecell = RecursiveListDataFilesInDir(main_dir);
    for filenum = 1:length(filecell)
        fullpath = filecell{filenum};
        filenamelist = split(fullpath,filesep);
        filename = filenamelist(end);
        if contains(filename, '._')
            % Skip this file if it starts with dot underline.
            continue;
        end
        varANDsite = split(filename,'_'); % i have made the filename in the format VARNAME_SITENAME.csv
        filevarheader = varANDsite{1};
        fileSiteStr = varANDsite{2}(1:end-4); %remove the .csv off end
        % fileSiteStr = ['wc_ploom_',fileSiteStr];
        SiteStruct = SearchSitelistbyStr(SiteListStruct,fileSiteStr);
        [AgencyStruct,StructVarIndex] = SearchVarlist(VarListStruct,filevarheader);
        if StructVarIndex == 0
            fprintf("Couldnt find %s\n",filevarheader)
            continue
        end
        VARID = AgencyStruct.ID;
        VarStruct = varkey.(VARID);
        
        [data,header] = filenamecreator(outdir,SiteStruct,VarStruct);
        Tab = readtable(fullpath);
        Tab{:,3} = Tab{:,3}*AgencyStruct.Conv;
        if ~exist(data,'file') %% this is because 'Chlorophyceae' and 'Chlorophyceae' (WCWA name) both link to Chlorophyta (our variable name)
            writelines('Date,Depth,Data,QC',data,'WriteMode','append');
        end
        writetable(Tab,data,'WriteMode','append');

        heightOrdepth = 'Depth';
        Deployment = 'Integrated';
        VerticalRef = 'Water Column';
                    temp = split(data,filesep);
                    filename_short = temp{end};
                    fid = fopen(header,'w');
                        fprintf(fid,'Agency Name,Water Corporation WA\n');
                        
                        fprintf(fid,'Agency Code,WCWA\n');
                        fprintf(fid,'Program,PLOOM\n');
                        fprintf(fid,'Project,Phyto\n');
                        fprintf(fid,'Tag,WCWA-PLOOM-PHY\n');
    
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
                        fprintf(fid,'Deployment Position,%s\n','Water Column'); % '0.0m above Seabed' 0m below surface);
                        fprintf(fid,'Vertical Reference,%s\n','Water Surface');
                        fprintf(fid,'Site Mean Depth,%4.4f\n',0);
                        %%
    
                        fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                        fprintf(fid,'Contact Email,%s\n','Lachy Gill <00114282@uwa.edu.au> 21/02/2025');
    
                        %%
                        fprintf(fid,'Variable ID,%s\n',VARID);
                        %%
                        
                        fprintf(fid,'Data Category,%s\n',VarStruct.Category);
    
                        fprintf(fid,'Sampling Rate (min),%4.4f\n',-1);                    
                        fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                        fprintf(fid,'Depth,Decimal\n');
                        
                        
                        fprintf(fid,'Variable,%s\n',VarStruct.Name);
                        fprintf(fid,'QC,String\n');
                    fclose(fid);
    end

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
    folderpath = [folderpath,'**/*.csv'];
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