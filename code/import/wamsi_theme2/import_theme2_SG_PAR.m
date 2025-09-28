function import_theme2_SGPAR()
    load ../../../code/actions/sitekey.mat;
    load ../../../code/actions/varkey.mat;
    load ../../../code/actions/agency.mat;

    run('../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-lake/WAMSI/WWMSP2/WWMSP2_SG_PAR/'];
    outdir = [datapath,'data-warehouse/csv/wamsi/wwmsp2/sg_par/'];

    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    VarListStruct = agency.wwmsp2;
    SiteListStruct = sitekey.wwmsp2;

    fprintf('This Code can use UTC and shift it +8 to get to perth timezone.\nOr\nIt can use local time as stored by the spreadsheet.\nUnfortunately these different methods give different results\n\n');

    fprintf('Currently the code uses UTC and shifts it to perth (+8 Hours)\n');

    fileStruct = dir([main_dir,'*.csv']);
    for SiteIndex = 1:length(fileStruct)
        filename = fullfile(fileStruct(SiteIndex).folder,fileStruct(SiteIndex).name);
        TAB = readtable(filename,"VariableNamingRule","preserve");

        SiteNum = TAB{1,11};
        SiteStruct = SearchSitelistbyShortNameContains(SiteListStruct,num2str(SiteNum));

        utc = TAB{:,2};
        perth1 = utc+8;
        perth2 = TAB{:,3} + TAB{:,4};
        date = perth1;
        date.Format = 'yyyy-MM-dd HH:mm:ss';

        for ColOfTab = 6:10 % hardcoded
           HeaderVarName = TAB.Properties.VariableNames{ColOfTab};
           AgencyStruct = SearchVarlist(VarListStruct,HeaderVarName);
           VarStruct = varkey.(AgencyStruct.ID);
           ReadInValues = TAB{:,ColOfTab};


           [fdata,fheader] = filenamecreator(outdir,SiteStruct,VarStruct);

            % Check if file exists
            if ~exist(fheader,'file')
                fid = fopen(fdata,'w');
                fprintf(fid,"Date,Height,Data,QC\n");
                fclose(fid);

                write_header(fheader,AgencyStruct.ID,VarStruct,SiteStruct);
                % create header and datafile
            end
            Depth = 0.2;
            QC = 'N';
            %Append to file
            fid = fopen(fdata,'a');
            for i = 1:length(ReadInValues)
                fprintf(fid,"%s,%f,%f,%s\n",char(date(i)),Depth,ReadInValues(i),QC);
            end
            fclose(fid);

        end

    end
end


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

function SiteStruct = SearchSitelistbyShortNameContains(SiteListStruct,Shortname)
    neverFound = true;
    SitelistFeilds = fields(SiteListStruct);
    NumOfVariables = length(SitelistFeilds);
   
    for StructSiteIndex = 1:NumOfVariables
                                                 
        if contains(SiteListStruct.(SitelistFeilds{StructSiteIndex}).Shortname,Shortname)
            SiteStruct = SiteListStruct.(SitelistFeilds{StructSiteIndex});
            neverFound = false;
            break
        end

    end
    if neverFound == true
        disp('DataFile site:');
        disp(Shortname)
        disp('Sitekey list:');
        for StructSiteIndex = 1:NumOfVariables
            disp(SiteListStruct.(SitelistFeilds{StructSiteIndex}).Shortname);                 
        end
        error('Didnt find the Site')
        %not a keyword, intentially stop the code because issue has happend
    end
end

function write_header(headerfile,varID,VarS,SiteS)
    filename = regexprep(headerfile,'_HEADER','_DATA');

    temp = split(filename,filesep);
    filename_short = temp{end};

    fid = fopen(headerfile,'wt');
                fprintf(fid,'Agency Name,Western Australian Marine Science Institution\n');
                
                fprintf(fid,'Agency Code,WAMSI\n');
                fprintf(fid,'Program,WWMSP2\n');
                fprintf(fid,'Project,WWMSP2_SG-PAR\n');
                fprintf(fid,'Tag,WAMSI-WWMSP2-SG-PAR\n');

                %%
                fprintf(fid,'Data File Name,%s\n',filename_short);
                fprintf(fid,'Location,%s\n',fullfile(temp{1:end-1}));
                %%
                
                fprintf(fid,'Station Status,Inactive\n');
                fprintf(fid,'Lat,%6.9f\n',SiteS.Lat);
                fprintf(fid,'Long,%6.9f\n',SiteS.Lon);
                fprintf(fid,'Time Zone,GMT +8\n');
                fprintf(fid,'Vertical Datum,mAHD\n');
                fprintf(fid,'National Station ID,%s\n',SiteS.ID);

                %%
                fprintf(fid,'Site Description,%s\n',SiteS.Description);
                fprintf(fid,'Deployment,%s\n','Fixed');
                fprintf(fid,'Deployment Position,%s\n','0.2m above Seabed');
                fprintf(fid,'Vertical Reference,%s\n','m above Seabed');
                fprintf(fid,'Site Mean Depth,%4.4f\n',0);
                %%

                fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                fprintf(fid,'Contact Email,%s\n','Lachy Gill <00114282@uwa.edu.au> 23/04/2025');

                %%
                fprintf(fid,'Variable ID,%s\n',varID);
                %%
                
                fprintf(fid,'Data Category,%s\n',VarS.Category);
                
                
        
                
                fprintf(fid,'Sampling Rate (min),%4.4f\n',-1);
                
                fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                fprintf(fid,'Depth,Decimal\n');
                
                
                fprintf(fid,'Variable,%s\n',VarS.Name);
                fprintf(fid,'QC,String\n');
                
                fclose(fid);
end
