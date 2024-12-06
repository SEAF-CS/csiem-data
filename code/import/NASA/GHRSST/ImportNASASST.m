function ImportNASASST()

    run('../../../actions/csiem_data_paths.m')

    main_dir = [datapath,'data-lake/NASA/GHRSST/ghrsst/'];
    Points_dir = fullfile(main_dir,'Points/');
    OffShorePolygon_dir = fullfile(main_dir,'Polygon_offshore/');
    NearShorePolygon_dir = fullfile(main_dir,'Polygon_nearshore/');

    outdir = [datapath,'data-warehouse/csv/nasa/ghrsst/'];



    if ~exist(outdir,'dir')
        mkdir(outdir);
    else
        delete([outdir,'*.csv'])
    end

    load ../../../actions/varkey.mat;
    load ../../../actions/agency.mat;
    load ../../../actions/sitekey.mat;

    AgencyStruct = agency.NASA.var1;
    if ~strcmp(AgencyStruct.ID,'var00007') == 1
        error('Varkey has changed order, Please change Line 24 of my code, to the correct var')
    end

    VarStruct = varkey.(AgencyStruct.ID);
    SiteListStruct = sitekey.VirtualSensors;

    %% Points
    PointOrPolyProcess("Point_%d",Points_dir,4,outdir,SiteListStruct,VarStruct,AgencyStruct);

    %% OffShorePolygon
    PointOrPolyProcess("OffShorePolygon_%d",OffShorePolygon_dir,2,outdir,SiteListStruct,VarStruct,AgencyStruct);

    %% NearShorePolygon
    PointOrPolyProcess("NearShorePolygon_%d",NearShorePolygon_dir,2,outdir,SiteListStruct,VarStruct,AgencyStruct);

end

function PointOrPolyProcess(SiteNameFormatStr,Directory,Datacol,outdir,SiteListStruct,VarStruct,AgencyStruct)
    Filenames = RecursiveListDataFilesInDir(Directory);
    for filenameNum = 1:length(Filenames) 
        filename = Filenames{filenameNum};
        if contains(filename, '._')
            % Skip this file if it starts with dot underline.
            continue;
        end
        PointNum = PointNumExtractor(filename);
        SiteName = sprintf(SiteNameFormatStr,PointNum);

        SiteStruct = SearchSitelistbyStr(SiteListStruct,SiteName);
        
        Tab = readtable(filename);
        %Tab(1:5,:)

        DataVals = Tab{:,Datacol}*AgencyStruct.Conv;
        DateVals = Tab{:,1};
        Depth = 0; %Sea surface
        [fDATA,fHEADER] = filenamecreator(outdir,SiteStruct,VarStruct);
        
        if ~exist(fDATA,'file')
            % Create header and data file
            fid = fopen(fDATA,'w');
            fprintf(fid,"Date,Depth,Data,QC\n");
            fclose(fid);

            HeaderWrite(fHEADER,fDATA,SiteStruct,VarStruct,AgencyStruct)
        end

        fid = fopen(fDATA,'a');
        for i = 1:height(Tab)
            fprintf(fid,"%s,%d,%f,N\n",DateVals(i),Depth,DataVals(i));
        end
        fclose(fid);
    end
end


function PointNum = PointNumExtractor(filename)
    tempVar = split(filename,'_');
    suffix = tempVar{end};
    PointNum = str2double(suffix(1:end-4));
end


function HeaderWrite(fHEADER,fDATA,SiteStruct,VarStruct,AgencyStruct)
    temp = split(fDATA,filesep);
    filename_short = temp{end};
    fid = fopen(fHEADER,'w');
    fprintf(fid,'Agency Name,The National Aeronautics and Space Administration\n');

    fprintf(fid,'Agency Code,NASA\n');
    fprintf(fid,'Program,GHRSST\n');
    fprintf(fid,'Project,ghrsst\n');
    fprintf(fid,'Tag,NASA-GHRSST\n');

    %%
    fprintf(fid,'Data File Name,%s\n',filename_short);
    fprintf(fid,'Location,%s\n',fullfile(temp{1:end-1}));
    %%

    fprintf(fid,'Station Status,Active\n');
    fprintf(fid,'Lat,%6.9f\n',SiteStruct.Lat);
    fprintf(fid,'Long,%6.9f\n',SiteStruct.Lon);
    fprintf(fid,'Time Zone,GMT +8\n');
    fprintf(fid,'Vertical Datum,mAHD\n');
    fprintf(fid,'National Station ID,%s\n',SiteStruct.AED);

    %%
    fprintf(fid,'Site Description,%s\n',SiteStruct.Description);
    fprintf(fid,'Deployment,%s\n','Satelite');
    fprintf(fid,'Deployment Position,%s\n','0.0m below Surface');
    fprintf(fid,'Vertical Reference,%s\n','Water Surface');
    fprintf(fid,'Site Mean Depth,%4.4f\n',0);
    %%

    fprintf(fid,'Bad or Unavailable Data Value,NaN\n');
    fprintf(fid,'Contact Email,%s\n','Lachy Gill <00114282@uwa.edu.au> 8/10/2024');

    %%
    fprintf(fid,'Variable ID,%s\n',AgencyStruct.ID);
    %%

    fprintf(fid,'Data Category,%s\n',VarStruct.Category);

    fprintf(fid,'Sampling Rate (min),%4.4f\n',-1);                    
    fprintf(fid,'Date,yyyy-mm-dd HH:MM:SS\n');
    fprintf(fid,'Depth,Decimal\n');


    fprintf(fid,'Variable,%s\n',VarStruct.Name);
    fprintf(fid,'QC,String\n');
    fclose(fid);
end

function SiteStruct = SearchSitelistbyStr(SiteListStruct,fileSite)
    neverFound = true;
    SitelistFeilds = fields(SiteListStruct);
    NumOfVariables = length(SitelistFeilds);

    for StructSiteIndex = 1:NumOfVariables
        StructSite = SiteListStruct.(SitelistFeilds{StructSiteIndex}).ID;
        
        if StructSite ==fileSite
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