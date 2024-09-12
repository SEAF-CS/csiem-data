function import_PhytoPlanktonSpecies()

    run('../../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-lake/DWER/Phyto/'];
    outdir = [datapath,'data-warehouse/csv/dwer/dwer_Phytoplankton/'];



    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../../actions/varkey.mat;
    load ../../../actions/agency.mat;
    load ../../../actions/sitekey.mat;

    VarListStruct = agency.DWER_Phytoplankton;
    SiteListStruct = sitekey.DWERPhyto;

    filecell = RecursiveListDataFilesInDir(main_dir);
    for SiteNum = 1:length(filecell)
        filename = filecell{SiteNum};
        opts = detectImportOptions(filename);
        T = readtable(filename,opts);
    
      
    
        %% date collected is in format dd/mm/yyyy we want it in yyyy-mm-dd HH:MM:SS
        T.("DateCollected").Format = 'yyyy-MM-dd';
        T.("DateCollected") = string(T.("DateCollected"));

        %Collect time is measured as a fraction of 24 hours
        TotMins = round(T.('Collect_Time')*24*60);
        TotMinsUnrounded = T.('Collect_Time')*24*60;

        %ensureing I wasnt changing values
        testa = abs(TotMinsUnrounded-TotMins)>0.01;
        sum(testa);
       
        hours = floor(TotMins/60);
        mins = rem(TotMins,60);
        
    
        for row = 1:height(T)

            speciesname = T{row,"Species_Name"}; % ie col 15
            AgencyStruct = SearchVarlist(VarListStruct,speciesname);
            VarStruct = varkey.(AgencyStruct.ID);
            CellsPermL = T{row,"Species_density_cells_per_ml"}* AgencyStruct.Conv; % ie col 17
            dateCollected = T{row,"DateCollected"}; % ie col 3
            timeCollected = sprintf("%02d:%02d:00",hours(row),mins(row));
            timestr = sprintf("%s %s",dateCollected,timeCollected);
            SiteString = T{row,"SiteRefName"}; % ie col 4
            Depth = 0;

            SiteStruct = SearchSitelistbyStrDWER(SiteListStruct,SiteString);
        

            
            % open and write to data file
            [fDATA,fHEADER] = filenamecreator(outdir,SiteStruct,VarStruct);

            if ~exist(fDATA,'file')
                fid = fopen(fDATA,'W');
                fprintf(fid,"Date,Depth,Data,QC\n");
                fclose(fid);

                fid = fopen(fHEADER,'w');
                    fprintf(fid,'Agency Name,Department of Water and Environmental Regulation\n');
                    
                    fprintf(fid,'Agency Code,DWER\n');
                    fprintf(fid,'Program,DWER Phytoplankton\n');
                    fprintf(fid,'Project,DWER_Phytoplankton\n');
                    fprintf(fid,'Tag,DWER_Phytoplankton_Species\n');

                    %%
                    fprintf(fid,'Data File Name,%s\n',fDATA);
                    fprintf(fid,'Location,N/A\n');
                    %%
                    
                    fprintf(fid,'Station Status,\n');
                    fprintf(fid,'Lat,%6.9f\n',SiteStruct.Lat);
                    fprintf(fid,'Long,%6.9f\n',SiteStruct.Lon);
                    fprintf(fid,'Time Zone,GMT +8\n');
                    fprintf(fid,'Vertical Datum,mAHD\n');
                    fprintf(fid,'National Station ID,%s\n',SiteStruct.AED);

                    %%
                    fprintf(fid,'Site Description,%s\n',SiteStruct.Description);
                    fprintf(fid,'Deployment,%s\n','Integrated');
                    fprintf(fid,'Deployment Position,%s\n','');% '0.0m above Seabed' 0m below surface);
                    fprintf(fid,'Vertical Reference,%s\n','');%  'm above Seabed'm below surface);
                    fprintf(fid,'Site Mean Depth,%4.4f\n',mean(Depth));
                    %%

                    fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
                    fprintf(fid,'Contact Email,%s\n','Lachy Gill, uwa email:00114282@uwa.edu.au 05/08/2024');

                    %%
                    fprintf(fid,'Variable ID,%s\n',AgencyStruct.ID);
                    %%
                    
                    fprintf(fid,'Data Category,%s\n',VarStruct.Category);
                    
                    
                    fprintf(fid,'Sampling Rate (min),%4.4f\n',NaN);
                    
                    fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
                    fprintf(fid,'Depth,Decimal\n');
                    
                    
                    fprintf(fid,'Variable,%s\n',VarStruct.Name);
                    fprintf(fid,'QC,String\n');
            fclose(fid);
            end
           

            fid = fopen(fDATA,'a');
            fprintf(fid,"%s,%f,%f,N\n",timestr,Depth,CellsPermL);
            fclose(fid);

            





        end
        % break;
        % This break is so that I only do one site
    end
end


function SiteStruct = SearchSitelistbyStrDWER(SiteListStruct,fileSiteStr)
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
    folderpath = [folderpath,'**/*.xlsx'];
    Root = dir(folderpath);
    for i =1:length(Root)
        filenameCell{i} = fullfile(Root(i).folder,Root(i).name);
    end
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
    filevar = regexprep(filevar,'/','.');
    filesite = SiteStruct.AED;

    base = [outpath,filesite,'_',filevar];
    data = [base,'_DATA.csv'];
    header = [base,'_HEADER.csv'];

end