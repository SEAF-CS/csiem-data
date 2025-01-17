clear all; close all;

filepath = 'V:\data-lake\westport\jppladcp\JPPL_AWAC\';

filelist = dir(fullfile(filepath, '**\*.mat'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

agency = 'JPPL';

for i = 1:length(filelist)
    
    data = load([filelist(i).folder,'/',filelist(i).name]);
    
    thesite = fieldnames(data.DATA);
    
    sitename = data.DATA.(thesite{1}).Description;
    
    
    awac.(sitename).V_y.Y = data.DATA.(thesite{1}).coordinates(2);
    awac.(sitename).V_y.X = data.DATA.(thesite{1}).coordinates(1);
    awac.(sitename).V_y.Agency = 'Westport';
    awac.(sitename).V_y.Data = data.DATA.(thesite{1}).V_y;
    awac.(sitename).V_y.Date = data.DATA.(thesite{1}).TIME_hydro;
    awac.(sitename).V_y.Depth = data.DATA.(thesite{1}).zcell;
    awac.(sitename).V_y.Agency = 'Westport';
    awac.(sitename).V_y.Program = 'JPPL';
    awac.(sitename).V_y.Sitename = sitename;
    awac.(sitename).V_y.Units = 'm^s';
    awac.(sitename).V_y.Variable_Name = 'V_y';
    
    awac.(sitename).V_x.Y = data.DATA.(thesite{1}).coordinates(2);
    awac.(sitename).V_x.X = data.DATA.(thesite{1}).coordinates(1);
    awac.(sitename).V_x.Agency = 'Westport';
    awac.(sitename).V_x.Data = data.DATA.(thesite{1}).V_x;
    awac.(sitename).V_x.Date = data.DATA.(thesite{1}).TIME_hydro;
    awac.(sitename).V_x.Depth = data.DATA.(thesite{1}).zcell;
    awac.(sitename).V_x.Agency = 'Westport';
    awac.(sitename).V_x.Program = 'JPPL';
    awac.(sitename).V_x.Sitename = sitename;   
    awac.(sitename).V_x.Units = 'm^s';
    awac.(sitename).V_x.Variable_Name = 'V_x';

    
    V = sqrt(power(awac.(sitename).V_x.Data,2) + power(awac.(sitename).V_y.Data,2));
    VD = (180 / pi) * atan2(-1*awac.(sitename).V_x.Data,-1*awac.(sitename).V_y.Data);
    
    awac.(sitename).Vmag.Y = data.DATA.(thesite{1}).coordinates(2);
    awac.(sitename).Vmag.X = data.DATA.(thesite{1}).coordinates(1);
    awac.(sitename).Vmag.Agency = 'Westport';
    awac.(sitename).Vmag.Data = V;
    awac.(sitename).Vmag.Date = data.DATA.(thesite{1}).TIME_hydro;
    awac.(sitename).Vmag.Depth = data.DATA.(thesite{1}).zcell;
    awac.(sitename).Vmag.Agency = 'Westport';
    awac.(sitename).Vmag.Program = 'JPPL';
    awac.(sitename).Vmag.Sitename = sitename;   
    awac.(sitename).Vmag.Units = 'm^s';    
    awac.(sitename).Vmag.Variable_Name = 'Velocity';

    awac.(sitename).Vdir.Y = data.DATA.(thesite{1}).coordinates(2);
    awac.(sitename).Vdir.X = data.DATA.(thesite{1}).coordinates(1);
    awac.(sitename).Vdir.Agency = 'Westport';
    awac.(sitename).Vdir.Data = VD;
    awac.(sitename).Vdir.Date = data.DATA.(thesite{1}).TIME_hydro;
    awac.(sitename).Vdir.Depth = data.DATA.(thesite{1}).zcell;
    awac.(sitename).Vdir.Agency = 'Westport';
    awac.(sitename).Vdir.Program = 'JPPL';
    awac.(sitename).Vdir.Sitename = sitename;   
    awac.(sitename).Vdir.Units = 'm^s';       
    awac.(sitename).Vdir.Variable_Name = 'Direction';

end
    
save awac.mat awac -mat;
