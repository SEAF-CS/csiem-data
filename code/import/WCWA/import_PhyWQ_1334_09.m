function import_PhyWQ_1334_09

addpath(genpath('../../functions/'));


load ../../../code/actions/sitekey.mat;
load ../../../code/actions/varkey.mat;
load ../../../code/actions/agency.mat;

VarkeyStruct = agency.WCWA;

%this grabs the datapath variable
run('../../actions/csiem_data_paths.m')

outdir = [datapath,'data-warehouse/csv/wcwa/wcwa-psdp-bmt349/'];mkdir(outdir);
%                         'D:\csiem\data-warehouse\csv\wcwa\wcwa-psdp-bmt349\';mkdir(outdir);

datafile = [datapath,'data-lake/WCWA/Working/Working/2018/BMT 349 Cockburn Sound Metocean Summary Report/Water Quality/1334_09_PhysicalWQ.xlsx'];
%'             D:\csiem\data-lake\WCWA\Working\Working\2018\BMT 349 Cockburn Sound Metocean Summary Report\Water Quality\1334_09_PhysicalWQ.xlsx';



siteA = sitekey.wc.wc_metocean_A;
siteB = sitekey.wc.wc_metocean_B;
siteC = sitekey.wc.wc_metocean_C;
siteD = sitekey.wc.wc_metocean_D;

siteA.Depth = 10;
siteB.Depth = 18;
siteC.Depth = 18;
siteD.Depth = 20;

%% These variables are in the same shape as the Big data arrays
vars = {...
'Temperature'
'Salinity'
'Dissolved Oxygen percentage'...
};
sites = {siteA,siteB,siteC,siteD};
depths = cell(1,1,3);depths(1,1,:) ={'Seabed';'Mid';'Surface'};

nvars =   length(vars);
nsites  = length(sites);
ndepths = length(depths);

%% function that Combines all the sheets of the excel document into 2 big objects
%Interograting BIGDATAArray(varIndex,SiteIndex,DepthIndex), where the indexes can be found by looking at the following variables:
% vars
% sites
% depths
[BIGDATAArray,BigDATEArray] = DataAquisitionFunc(datafile,vars,sites,depths);

%% Loops through all data and outputs csv files for each (skips )
for VarIndex = 1:nvars
    disp(['Processing Variable ',vars{VarIndex}])
    VarStruct = SearchVarlist(VarkeyStruct,vars,VarIndex);
    VarID = VarStruct.ID; 

    for SiteIndex = 1:nsites
        SiteStruct = sites{SiteIndex};
        siteName = ['site',SiteStruct.ID];
        disp(['     Processing Site ',siteName])

        for DepthIndex = 1:ndepths
            disp(['         Processing Depth ',depths{DepthIndex}])
            if DepthIndex == 1
                %seabed
                Depth = 0.5;
            elseif DepthIndex == 2
                % mid
                Depth = SiteStruct.Depth/2;
            
            elseif DepthIndex == 3
                % surface
                Depth = SiteStruct.Depth-1.3;
            else
                disp('Depth index is invalid')
                stop
            end

            filenamevar = regexprep(vars{VarIndex},' ','');
            filecode = [siteName,'_',depths{DepthIndex},'_',filenamevar];
            Date = BigDATEArray{VarIndex,SiteIndex,DepthIndex};
            Data = BIGDATAArray{VarIndex,SiteIndex,DepthIndex};
            Func(filecode,Date,Data,Depth,outdir,SiteStruct,VarID,varkey);
        end
    end
end

end


function FunctionisedCsvWriter(filecode,DateColVec,DataColVec,SiteDepth,outdir,SiteStruct,VarID,varkeyStruct)

    ValidIndexes = find(~isnan(DataColVec) == 1);
    DateEntries = DateColVec(ValidIndexes);
    DataEntries = DataColVec(ValidIndexes);
    DepthEntries = SiteDepth*ones(length(ValidIndexes),1);
    if ValidIndexes
        write_psdp_data(outdir,SiteStruct,VarID,varkeyStruct,DateEntries,DataEntries,DepthEntries,filecode);
    else
        disp(ValidIndexes)
        disp('              No valid entries')
    end
end

function VarStruct = SearchVarlist(VarListStruct,FileHeaders,varIndex)
    % VarStruct = SearchVarlist(VarListStruct,FileHeaders,varIndex)
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
        disp(FileHeaders{varIndex})
        for StructVarIndex = 1:NumOfVariables
            disp(VarListStruct.(VarlistFeilds{StructVarIndex}).Old)
        end
        stop
        %not a keyword, intentially stop the code because issue has happend
    end

end

function [BIGDATAArray,BIGDATEArray] = DataAquisitionFunc(datafile,vars,sites,depths)

    nvars =   length(vars);
    nsites  = length(sites);
    ndepths = length(depths);

    BIGDATAArray = cell(nvars,nsites,ndepths,1);
    BIGDATEArray = cell(nvars,nsites,ndepths,1);

    %as of writing code
    % view the variables vars, sites and depths and consult the table below
    %vars
    %1 = temp
    %2 = salinity
    %3 = Dissovlved oxygen sat

    %site
    %1 a
    %2 b
    %3 c
    %4 d

    %depth
    % 1 = Seabed
    % 2 mid water
    % 3 surface

    %% Temperature
    warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
    temperatureTable = readtable(datafile,'Range','A1:L12313','Sheet','Temperature ');
    warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
    
    ColDataIndexes = {[1,1,1],[1,1,3],[1,2,1],[1,2,2],[1,2,3],[1,3,1],[1,3,2],[1,3,3],[1,4,1],[1,4,2],[1,4,3]};
    [BIGDATAArray,BIGDATEArray] = iterateThroughColumns(temperatureTable,BIGDATAArray,BIGDATEArray,ColDataIndexes);
    
    %% Salinty

    warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
    saldata = readtable(datafile,'Range','A1:L12312','Sheet','Salinity');
    warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
    ColDataIndexes = {[2,1,1],[2,1,3],[2,2,1],[2,2,2],[2,2,3],[2,3,1],[2,3,2],[2,3,3],[2,4,1],[2,4,2],[2,4,3]};
    [BIGDATAArray,BIGDATEArray] = iterateThroughColumns(saldata,BIGDATAArray,BIGDATEArray,ColDataIndexes);

    %% Disolved 
    warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
    disTable = readtable(datafile,'Range','A1:E37630','Sheet','DO');
    warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
    ColDataIndexes = {[3,1,1],[3,2,1],[3,3,1],[3,4,1]};
    [BIGDATAArray,BIGDATEArray] = iterateThroughColumns(disTable,BIGDATAArray,BIGDATEArray,ColDataIndexes);
    
    warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
    disTable = readtable(datafile,'Range','H1:J6157','Sheet','DO');
    warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
    ColDataIndexes = {[3,1,3]};
    [BIGDATAArray,BIGDATEArray] = iterateThroughColumns(disTable,BIGDATAArray,BIGDATEArray,ColDataIndexes);

end

function [BIGDATAArray,BIGDATEArray] = iterateThroughColumns(DataTable,BIGDATAArray,BIGDATEArray,ColDataIndexes)
    DateVec = datenum(DataTable{:,1});
    colN = length(ColDataIndexes);
    for col = 1:colN
        v = ColDataIndexes{col}(1);
        s = ColDataIndexes{col}(2);
        d = ColDataIndexes{col}(3);
        currentColData = DataTable{:,col+1};
        colLength = length(currentColData);
        BIGDATAArray{v,s,d} = currentColData;
        BIGDATEArray{v,s,d} = DateVec(1:colLength);
    end
end
