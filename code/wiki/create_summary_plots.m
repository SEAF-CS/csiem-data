clear all; close all;

runlocal = 1;

if ~runlocal
    
    load V:/data-warehouse/mat/seaf.mat;
    
else
    load Y:/csiem/data-warehouse/mat/seaf.mat;
end
agencies = [];


sidebar = fopen('sidebar_image.txt','wt');
sidebar2 = fopen('sidebar_image_2.txt','wt');

fprintf(sidebar,'## Data\n');

sites = fieldnames(seaf);

for i = 1:length(sites)
    vars = fieldnames(seaf.(sites{i}));
    
    agencies = [agencies;{seaf.(sites{i}).(vars{1}).Agency_Code}];
    
end

uagencies = unique(agencies);

for i = 1:length(uagencies)
    projects = [];
    for j = 1:length(sites)
        vars = fieldnames(seaf.(sites{j}));
        
        if strcmpi(uagencies{i},seaf.(sites{j}).(vars{1}).Agency_Code) == 1
            projects = [projects;{seaf.(sites{j}).(vars{1}).Program_Code}];
        end
    end
    comp.(uagencies{i}).Project = unique(projects);
end

for i = 1:length(uagencies)
    for j = 1:length(comp.(uagencies{i}).Project)
        thefilename = [uagencies{i},'_',comp.(uagencies{i}).Project{j},'.md'];
        
        thefid = fopen(['../../../cseim-data-wiki/',thefilename],'wt');
        
        fprintf(thefid,'#%s\n',[uagencies{i},': ',comp.(uagencies{i}).Project{j}]);
        
        for kk = 1:4; fprintf(thefid,'\n'); end
        
        thecode = [uagencies{i},': ',comp.(uagencies{i}).Project{j}];
        
        fprintf(sidebar,'- [%s][%s]\n',thecode,comp.(uagencies{i}).Project{j});
        
        fprintf(sidebar2,'[%s]: %s\n',comp.(uagencies{i}).Project{j},[' https://github.com/AquaticEcoDynamics/csiem-data/wiki/',regexprep(thefilename,'.md','')]);
        
        
        
        figure
        gx = geoaxes;
        
        %         mapshow('background.png');hold on
        %
        %         axis equal;
        %         axis off;
        %         grid off;
        
        aLat = [];
        aLon = [];
        aLab = [];
        
        aSites = [];
        
        for k = 1:length(sites)
            vars = fieldnames(seaf.(sites{k}));
            
            if strcmpi(comp.(uagencies{i}).Project{j},seaf.(sites{k}).(vars{1}).Program_Code) == 1
                geoscatter(seaf.(sites{k}).(vars{1}).Lat,seaf.(sites{k}).(vars{1}).Lon,"o",'filled','markerfacecolor','w');hold on
                %                 text(seaf.(sites{k}).(vars{1}).Lon + 0.05,seaf.(sites{k}).(vars{1}).Lat + 0.05,regexprep(seaf.(sites{k}).(vars{1}).Station_ID,'_',' '),...
                %                     'fontsize',4);
                aLat = [aLat;seaf.(sites{k}).(vars{1}).Lat];
                aLon = [aLon;seaf.(sites{k}).(vars{1}).Lon];
                aLab = [aLab;{regexprep(seaf.(sites{k}).(vars{1}).Station_ID,'_',' ')}];
                aSites = [aSites;sites(k)];
            end
        end
        
        geobasemap('satellite'); pause(10);
        
        for kkk = 1:length(aLab)
            text(aLat(kkk),aLon(kkk),aLab{kkk},...
                'fontsize',8,'fontweight','bold','color','w');
        end
        nzoom = 8.9626;
        if strcmpi(uagencies{i},'IMOS') == 1
            gx.ZoomLevel = nzoom;
        end
        
        %         xlim([min(aLon)-0.5 max(aLon)+0.5]);
        %         ylim([min(aLat)-0.5 max(aLat)+0.5]);
        
        %--% Paper Size
        set(gcf, 'PaperPositionMode', 'manual');
        set(gcf, 'PaperUnits', 'centimeters');
        xSize = 20;
        ySize = 20;
        xLeft = (21-xSize)/2;
        yTop = (30-ySize)/2;
        set(gcf,'paperposition',[0 0 xSize ySize])
        
        saveas(gcf,['../../../cseim-data-wiki/images/',uagencies{i},'_',comp.(uagencies{i}).Project{j},'.png']);
        
        close;
        
        txt = ['![Basemap](https://github.com/AquaticEcoDynamics/csiem-data/wiki/images/',uagencies{i},'_',comp.(uagencies{i}).Project{j},'.png "Basemap")'];
        
        
        
        
        
        
        fprintf(thefid,'%s\n',txt);
        
        for kk = 1:length(aSites)
            for kkk = 1:2; fprintf(thefid,'\n'); end
            
            filename = run_site_plots(aSites{kk},seaf);
            
            thefiletxt = ['Data Plots: [',aSites{kk},'](',filename,')'];
            
            fprintf(thefid,'%s\n',thefiletxt);
            
        end
        
        fclose(thefid);
        
    end
    
    
end
fclose(sidebar);

create_sidebar;

