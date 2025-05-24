%function declariton
load ../../../actions/varkey.mat;
load ../../../actions/agency.mat;
load ../../../actions/sitekey.mat;


VarListStruct = agency.wwmsp3;
SiteListStruct = sitekey.wwmsp33Porewater;

run('../../../actions/csiem_data_paths.m')
outdir = [datapath,'data-warehouse/csv/wamsi/wwmsp3/porewater/'];

if exist(outdir,"dir")
    delete([outdir,'*.csv'])
else
    mkdir(outdir);
end

infile = [datapath,'data-lake/WAMSI/WWMSP3/WWMSP3.3_Porewater/Copy of WWMSP3.3_CombinedSampleDetails_BeachOffshorePorewater_PRELIMINARY_072024.xlsx'];
% 3 readtables, one for each sheet

%% Insit

Insit = readtable(infile,'sheet','InSituParameters');
Insit = Insit(2:end,:);
% removes blank row

% Insert depth based on Sample Type
for rowInd = 1:height(Insit)
    if isnan(Insit{rowInd,6})
        SampleTypeStr = Insit{rowInd,5}{1};
        Depth(rowInd) = SampleTypeDepthConv(SampleTypeStr);
   else
    Depth(rowInd) = Insit{rowInd,6};
   end

end


for colInd = 7:9
    Varname = Insit.Properties.VariableNames{colInd};
    AgencyStruct = SearchVarlist(VarListStruct,Varname);
    VarStruct = varkey.(AgencyStruct.ID);

    for rowInd = 1:height(Insit)
        SiteId = Insit{rowInd,1};
       SiteStruct =  SearchSitelistbyID(SiteListStruct,SiteId);

       [fdata,fheader] = filenamecreator(outdir,SiteStruct,VarStruct);
    %    fid = fopen("here.txt",'a');
    %    fprintf(fid,"%s\n",fdata);
    %    fclose(fid)
       if ~exist(fdata,'file')
        % make the files
        fid = fopen(fdata,'w');
        fprintf(fid,'Date,Depth,Data,QC\n');
        fclose(fid);

        %header creation
        DeploymentPos = 'Not Done';
        VertRef = 'Not Done';
        write_header(fheader,AgencyStruct.ID,VarStruct,SiteStruct,DeploymentPos,VertRef)
       end

       DStr = DatetimeBuilder(Insit{rowInd,3},Insit{rowInd,4});
       %append this piece of data

       Data = Insit{rowInd,colInd};
       Qc = 'N';
       fid = fopen(fdata,'a');
       fprintf(fid, "%s,%f,%f,%s\n",DStr,Depth(rowInd),Data,Qc);
       fclose(fid);


    end

end

%% Mafrl

Mafrl = readtable(infile,'sheet','MAFRL_samples');
numberCols  = 6:23;
Precision = Mafrl{1,numberCols};

%Get ride of blank cells
Mafrl = Mafrl(3:end,:);
MafrlNumbersArray = Mafrl{:,numberCols};
NaNIndexes = isnan(MafrlNumbersArray);

for colNum = 1:length(numberCols)
    % fill in the nans with the Precion of the same col (one column at a time)
    % This only works because there was no missing values/ Nans that werent the less than sign
    
    MafrlNumbersArray(NaNIndexes(:,colNum),colNum) = Precision(1,colNum)/2;
end

Mafrl{:,numberCols} = MafrlNumbersArray;

% Insert depth based on Sample Type
for rowInd = 1:height(Mafrl)
        SampleTypeStr = Mafrl{rowInd,5}{1};
        Depth(rowInd) = SampleTypeDepthConv(SampleTypeStr);
end

count = 1;
TESTATab = table();
for colInd = numberCols
    Varname = Mafrl.Properties.VariableDescriptions{colInd};
    AgencyStruct = SearchVarlist(VarListStruct,Varname);
    VarStruct = varkey.(AgencyStruct.ID);

    for rowInd = 1:height(Mafrl)
        SiteId = Mafrl{rowInd,1};
       SiteStruct =  SearchSitelistbyID(SiteListStruct,SiteId);

       [fdata,fheader] = filenamecreator([outdir,'MAFRL_'],SiteStruct,VarStruct);

       
    %    fid = fopen("here.txt",'a');
    %    fprintf(fid,"%s\n",fdata);
    %    fclose(fid)
       if ~exist(fdata,'file')
        % make the files
        fid = fopen(fdata,'w');
        fprintf(fid,'Date,Depth,Data,QC\n');
        fclose(fid);

        %header creation
        DeploymentPos = 'Not Done';
        VertRef = 'Not Done';
        write_header(fheader,AgencyStruct.ID,VarStruct,SiteStruct,DeploymentPos,VertRef)
       end

       DStr = DatetimeBuilder(Mafrl{rowInd,3},Mafrl{rowInd,4});
       %append this piece of data

       TESTATab(count,1:3) = table({fdata},Mafrl{rowInd,5},{DStr});
       count = count +1;

       Data = Mafrl{rowInd,colInd};
       Qc = 'N';
       fid = fopen(fdata,'a');
       fprintf(fid, "%s,%f,%f,%s\n",DStr,Depth(rowInd),Data,Qc);
       fclose(fid);


    end

end
writetable(TESTATab,'testa.csv');




% i need to get the correct datatypes, where < is recorded as half smallest measurement
% workout which are underground and which arent 
% ie if it is porewater its underground
% Seawater is obviously water

% end
function depth = SampleTypeDepthConv(SampleTypeStr)
    switch SampleTypeStr
        case 'Offshore porewater'
            depth = -0.5; % because it is a Height being stored incorrectly
         
        case 'Beach porewater'
            depth = -0.5; % because it is a Height being stored incorrectly

        case 'Seawater'
            depth = 0.5; % this is an actual depth  
            
        otherwise 
            disp('something gone wrong')
            error('This function has received a Sample Type it was not expecting')
            
    end

end

function fulldate = DatetimeBuilder(Date,Time)
    fulldate = Date +Time;
    fulldate.Format = "yyyy-MM-dd HH:mm:ss";
    fulldate = char(fulldate);
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

function SiteStruct = SearchSitelistbyID(SiteListStruct,ID)
    neverFound = true;
    SitelistFeilds = fields(SiteListStruct);
    NumOfVariables = length(SitelistFeilds);
   
    for StructSiteIndex = 1:NumOfVariables
                                                 
        if strcmp(ID,SiteListStruct.(SitelistFeilds{StructSiteIndex}).ID)
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
            disp(SiteListStruct.(SitelistFeilds{StructSiteIndex}).ID);                 
        end
        stop
        %not a keyword, intentially stop the code because issue has happend
    end
end

function [data,header] = filenamecreator(outpath,SiteStruct,VarStruct)
    filevar = regexprep(VarStruct.Name,' ','_');
    filesite = SiteStruct.AED;

    base = [outpath,filesite,'_',filevar];
    data = [base,'_DATA.csv'];
    header = [base,'_HEADER.csv'];

end