%% This Script Needs the following files
%ZooMarvlRegionNames.csv
%ZooMarvlVarNames.csv

%% This script outputs
% PrettyPics, which is a collection of all the ZooMarvl Pictures
% ZooMarvlFileNames.csv- A list of all of the paths to the images I have copied into PrettyPics

%% Inputs
RootDir = '/GIS_DATA/csiem-data-hub/marvl-images/all/';
RegionNames = readcell('./ZooMarvlRegionNames.csv');
VarNames = readcell('ZooMarvlVarNames.csv','Delimiter',',');

%% Outputs
PrettyPictures = './PrettyPics/';
mkdir(PrettyPictures);
ZOOPFilePaths = 'ZooMarvlFileNames.csv';




counter = 1;

for VarInd = 1:length(VarNames)
    VarName = VarNames{VarInd};
    
    % Find the folder for this variable
    path = fullfile(RootDir,VarName);

    for RegionInd = 1:length(RegionNames)
        RegionName = RegionNames{RegionInd};
        RegionName =  replace(RegionName,'-','_');
        S = dir(path);
        List = S(contains({S.name}, RegionName));
        if isempty(List)
            fprintf("%s,%s\n",VarName,RegionName);

        else
            FullPathList{counter} = fullfile(path,List.name);
            copyfile(FullPathList{counter},fullfile(PrettyPictures,sprintf("%s  %s.png",VarName,RegionName)));
            counter = counter+1;
        end
    end
end
writecell(FullPathList,ZOOPFilePaths);