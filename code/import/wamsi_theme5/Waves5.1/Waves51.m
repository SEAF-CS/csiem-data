function Waves51()
    run('../../../actions/csiem_data_paths.m')
    main_dir = [datapath,'data-lake/WAMSI/wwmsp5.1_waves/'];
    outdir = [datapath,'data-warehouse/csv/wamsi/wwmsp5.1_waves/'];
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end
    load ../../../actions/varkey.mat;
    load ../../../actions/agency.mat;
    load ../../../actions/sitekey.mat;
    VarListStruct = agency.theme51waves;
    SiteListStruct = sitekey.wwmsp5;

    headers = headercreator();
    filecell = RecursiveListDataFilesInDir(main_dir);
    for SiteNum = 1:length(filecell)
        filename = filecell{SiteNum}
        SiteString = siteExtractor(filename);
        SiteStruct = SearchSitelistbyStr(SiteListStruct,SiteString);

        T = readtable(filename);
        Temp = T(:,1:16);
        Temp.Properties.VariableNames = headers(1:16)';

        % Construct time vec
        timeStr = TimeConstructor(Temp);
        Depth = Temp.Depth/1000;


        for VarNum = 1:width(Temp)
            if VarNum ~= 9:14 % currently these are the vars in the varkey
                continue
            end
            
            FileVarHeader = Temp.Properties.VariableNames{VarNum};
            AgencyStruct = SearchVarlist(VarListStruct,FileVarHeader);
            VarStruct = varkey.(AgencyStruct.ID);

            Data = Temp{:,VarNum}* AgencyStruct.Conv;

            % open and write to data file
            [fDATA,fHEADER] = filenamecreator(outdir,SiteStruct,VarStruct);
            fid = fopen(fDATA,'W');
            fprintf(fid,"Date,Depth,Data,QC\n");
            for i = 1:height(Temp)
                fprintf(fid,"%s,%f,%f,N\n",timeStr(i),Depth(i),Data(i));
            end
            fclose(fid);
            fid = fopen(fHEADER,'w');
                    fprintf(fid,'Agency Name,Western Australian Marine Science Institution\n');
                    
                    fprintf(fid,'Agency Code,WAMSI\n');
                    fprintf(fid,'Program,WAMSI Westport Marine Science Program\n');
                    fprintf(fid,'Project,WAMSI-WWMSP5.1-Waves\n');
                    fprintf(fid,'Tag,WAMSI-WWMSP5.1-Waves\n');

                    %%
                    fprintf(fid,'Data File Name,%s\n',filename);
                    fprintf(fid,'Location,%s\n','N/A');%main_dir');
                    %%
                    
                    fprintf(fid,'Station Status,\n');
                    fprintf(fid,'Lat,%6.9f\n',SiteStruct.Lat);
                    fprintf(fid,'Long,%6.9f\n',SiteStruct.Lon);
                    fprintf(fid,'Time Zone,GMT +8\n');
                    fprintf(fid,'Vertical Datum,mAHD\n');
                    fprintf(fid,'National Station ID,%s\n',SiteStruct.AED);

                    %%
                    fprintf(fid,'Site Description,%s\n',SiteStruct.Description);
                    fprintf(fid,'Deployment,%s\n','Floating');
                    fprintf(fid,'Deployment Position,%s\n','0m below surface');
                    fprintf(fid,'Vertical Reference,%s\n','m below surface');
                    fprintf(fid,'Site Mean Depth,%4.4f\n',mean(Depth));
                    %%

                    fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                    fprintf(fid,'Contact Email,%s\n','Lachy Gill, uwa email:00114282@uwa.edu.au 05/04/2024');

                    %%
                    fprintf(fid,'Variable ID,%s\n',AgencyStruct.ID);
                    %%
                    
                    fprintf(fid,'Data Category,%s\n',VarStruct.Category);
                    
                    
                    SD = mean(diff(Temp.HH));
                    
                    fprintf(fid,'Sampling Rate (min),%4.4f\n',SD * 60);
                    
                    fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                    fprintf(fid,'Depth,Decimal\n');
                    
                    
                    fprintf(fid,'Variable,%s\n',VarStruct.Name);
                    fprintf(fid,'QC,String\n');
            fclose(fid);





        end
        % break;
        % This break is so that I only do one site
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

function headers = headercreator()
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