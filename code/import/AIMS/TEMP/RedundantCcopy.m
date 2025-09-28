function AIMS(n)
    run ../../actions/csiem_data_paths

    % load ../../actions/varkey.mat;
    % load ../../actions/agency.mat;
    % agency.AIMS
    % load ../../actions/sitekey.mat;
    % sitekey.AIMS

    % indir = [datapath,'data-lake/AIMS/temp-logger-data/HEADtemp-logger-data.csv'];
    indir = [datapath,'data-lake/AIMS/temp-logger-data/temp-logger-data.csv'];
    
    outdir = [datapath,'data-warehouse/csv/aims/'];
    if exist(outdir)
        %%% I want to create each file and header then append each data entry, which means a clean slate each time
        rmdir(outdir);
        mkdir(outdir);
    end
    
    % "%*d,%[^\t\n,],%d,%*[^,],%*d,%*[^,],%*[^,],%d,%[^\t\n,],%*[^,],%*[^,],%f,%f,%*[^,],%*[^,],%*d,%[^,],%f,%*f,%*d\n"
    format = "%*d,%[^\t\n,],%d,%*[^,],%*d,%*[^,],%*[^,],%d,%[^\t\n,],%*[^,],%*[^,],%f,%f,%*[^,],%*[^,],%*d,%[^,],%f,%*f,%*d\n";
    
    FID = fopen(indir,'r');
    Line = fgets(FID);
    for i = 1:n
        Line = fgets(FID);
        if Line == -1
            break
        end

        strings = sscanf(Line,format)'
        char(strings)
        % site = char(sscanf(Line,"%*d,%[^\t\n,],%*d,%*[^,],%*d,%*[^,],%*[^,],%*d,%*[^\t\n,],%*[^,],%*[^,],%*f,%*f,%*[^,],%*[^,],%*d,%*[^,],%*f,%*f,%*d\n"));
        % siteid = sscanf(Line,"%*d,%*[^\t\n,],%d,%*[^,],%*d,%*[^,],%*[^,],%*d,%*[^\t\n,],%*[^,],%*[^,],%*f,%*f,%*[^,],%*[^,],%*d,%*[^,],%*f,%*f,%*d\n");
        % depth = sscanf(Line,"%*d,%*[^\t\n,],%*d,%*[^,],%*d,%*[^,],%*[^,],%d,%*[^\t\n,],%*[^,],%*[^,],%*f,%*f,%*[^,],%*[^,],%*d,%*[^,],%*f,%*f,%*d\n");
        % var = char(sscanf(Line,"%*d,%*[^\t\n,],%*d,%*[^,],%*d,%*[^,],%*[^,],%*d,%[^\t\n,],%*[^,],%*[^,],%*f,%*f,%*[^,],%*[^,],%*d,%*[^,],%*f,%*f,%*d\n"));
        % lat = sscanf(Line,"%*d,%*[^\t\n,],%*d,%*[^,],%*d,%*[^,],%*[^,],%*d,%*[^\t\n,],%*[^,],%*[^,],%f,%*f,%*[^,],%*[^,],%*d,%*[^,],%*f,%*f,%*d\n");
        % lon = sscanf(Line,"%*d,%*[^\t\n,],%*d,%*[^,],%*d,%*[^,],%*[^,],%*d,%*[^\t\n,],%*[^,],%*[^,],%*f,%f,%*[^,],%*[^,],%*d,%*[^,],%*f,%*f,%*d\n");
        % time = char(sscanf(Line,"%*d,%*[^\t\n,],%*d,%*[^,],%*d,%*[^,],%*[^,],%*d,%*[^\t\n,],%*[^,],%*[^,],%*f,%*f,%*[^,],%*[^,],%*d,%[^,],%*f,%*f,%*d\n"));
        % val = sscanf(Line,"%*d,%*[^\t\n,],%*d,%*[^,],%*d,%*[^,],%*[^,],%*d,%*[^\t\n,],%*[^,],%*[^,],%*f,%*f,%*[^,],%*[^,],%*d,%*[^,],%f,%*f,%*d\n");
        end

    

%     VarListStruct = agency.;
%     SiteListStruct = sitekey.;

    % for i = 1:height(T)

        

    %     % find var
    %     % index 9

    %     % find site
    %     % index 2 and 3

    %     % depth, index 8

    %     % lat and long 12 and 13
    %     % time 17
    %     % numerical val 18
    % end



%     
%         SiteStruct = SearchSitelistbyLatLong(SiteListStruct,lat,lon);
        
%             AgencyStruct = SearchVarlist(VarListStruct,Vars,varIndex);
%             VarStruct = varkey.(AgencyStruct.ID);

        % if doesnt exit make
        % else
        %     add data
%             [fnameData,fnameHeader] = filenamecreator(outdir,SiteStruct,VarStruct);







            

%             fid = fopen(fnameData,'W');
%             fprintf(fid,'Date,Depth,Data,QC\n');
%             DataVec = waves.(Sites{i}).(Vars{varIndex}).data;
%             DateVec = waves.(Sites{i}).(Vars{varIndex}).date;
%             DateString = datestr(DateVec,"yyyy-mm-dd HH:MM:SS");
            
%             for nn = 1:length(DataVec)
%                 % DateString = datestr(DateVec(nn),"yyyy-mm-dd HH:MM:SS");
%                 Depth = 0;
%                 QC = 'N';
%                 fprintf(fid,'%s,%4.4f,%4.4f,%s\n',DateString(nn),Depth,DataVec(nn),QC);
%             end
%             fclose(fid);

            
%             lat = SiteStruct.Lat;
%             lon = SiteStruct.Lon;
%             ID = SiteStruct.ID;
%             Desc = SiteStruct.Description;
%             varID = AgencyStruct.ID;
%             Cat = VarStruct.Category;
%             varstring = VarStruct.Name;
%             wdate = '';
%             sitedepth = '';
%             %%bad code practise by copied from
%             %csiem-data-hub/git/code/import/wamsi_theme3/SEDPSD/Functions/write_header
%             write_header(fnameHeader,lat,lon,ID,Desc,varID,Cat,varstring,wdate,sitedepth)

%         end
%     end

% end


% function VarStruct = SearchVarlist(VarListStruct,FileHeaders,varIndex)
%     neverFound = true;
%     VarlistFeilds = fields(VarListStruct);
%     NumOfVariables = length(VarlistFeilds);

%     FileVarHeader = FileHeaders{varIndex};

%     for StructVarIndex = 1:NumOfVariables
%         StructVarHeader = VarListStruct.(VarlistFeilds{StructVarIndex}).Old;
%         % Check if FileVarHeader == StructVarHeader
%         if strcmp(FileVarHeader,StructVarHeader)
%             VarStruct = VarListStruct.(VarlistFeilds{StructVarIndex});
%             neverFound = false;
%             break
%         end

%     end
%     if neverFound == true
%         disp(FileHeaders{varIndex})
%         for StructVarIndex = 1:NumOfVariables
%             disp(VarListStruct.(VarlistFeilds{StructVarIndex}).Old)
%         end
%         stop
%         %not a keyword, intentially stop the code because issue has happend
%     end

% end

% function SiteStruct = SearchSitelistbyLatLong(SiteListStruct,fileLat,fileLon)
%     neverFound = true;
%     SitelistFeilds = fields(SiteListStruct);
%     NumOfVariables = length(SitelistFeilds);
%     fileSiteLatLonPair = [fileLat fileLon];
%     %disp(fileSiteLatLonPair)

%     for StructSiteIndex = 1:NumOfVariables
%         StructSiteLatLonPair = [SiteListStruct.(SitelistFeilds{StructSiteIndex}).Lat ...
%                                 SiteListStruct.(SitelistFeilds{StructSiteIndex}).Lon];
                                
%         %disp(StructSiteLatLonPair)                 
%         if fileSiteLatLonPair == StructSiteLatLonPair
%             SiteStruct = SiteListStruct.(SitelistFeilds{StructSiteIndex});
%             neverFound = false;
%             break
%         end

%     end
%     if neverFound == true
%         disp(fileSiteLatLonPair)
%         disp('Onto sites now')
%         for StructSiteIndex = 1:NumOfVariables
%             disp(SiteListStruct.(SitelistFeilds{StructSiteIndex}).ID)
%             disp([SiteListStruct.(SitelistFeilds{StructSiteIndex}).Lat ...
%                                 SiteListStruct.(SitelistFeilds{StructSiteIndex}).Lon]);
                                
%         end
%         stop
%         %not a keyword, intentially stop the code because issue has happend
%     end
% end

% function [data,header] = filenamecreator(outpath,SiteStruct,VarStruct)
%     filevar = regexprep(VarStruct.Name,' ','_');
%     filesite = SiteStruct.AED;

%     base = [outpath,filesite,'_',filevar];
%     data = [base,'_DATA.csv'];
%     header = [base,'_HEADER.csv'];

% end

