function filename = run_site_plots(site,seaf)


vars = fieldnames(seaf.(site));

agency = regexprep(seaf.(site).(vars{1}).Agency_Code,'-','_');
project = regexprep(seaf.(site).(vars{1}).Program_Code,'-','_');


outdir = ['../../../cseim-data-wiki/images/summary/',agency,'/',project,'/',site,'/'];

if ~exist(outdir,'dir')
    mkdir(outdir);
end

filename = ['https://github.com/AquaticEcoDynamics/csiem-data/wiki/',agency,'_',project,'_',site];

writefile = ['../../../cseim-data-wiki/',agency,'_',project,'_',site,'.md'];

fid = fopen(writefile,'wt');

fprintf(fid,'## %s\n',regexprep(agency,'_',' '));

fprintf(fid,'## %s\n',regexprep(project,'_',' '));

fprintf(fid,'### %s\n',regexprep(seaf.(site).(vars{1}).Station_ID,'_',' '));


figure
gx = geoaxes;

geoscatter(seaf.(site).(vars{1}).Lat,seaf.(site).(vars{1}).Lon,"o",'filled','markerfacecolor','w');hold on

geobasemap('satellite'); pause(10);

text(seaf.(site).(vars{1}).Lat,seaf.(site).(vars{1}).Lon,seaf.(site).(vars{1}).Station_ID,...
    'fontsize',8,'fontweight','bold','color','w');


nzoom = 8.9626;
gx.ZoomLevel = nzoom;

set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
xSize = 20;
ySize = 20;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize])

saveas(gcf,[outdir,'Map.png']);

txt = ['![Basemap](https://github.com/AquaticEcoDynamics/csiem-data/wiki/images/summary/',agency,'/',project,'/',site,'/Map.png "Basemap")'];

fprintf(fid,'%s\n',txt);            for kkk = 1:2; fprintf(fid,'\n'); end



for j = 1:length(vars)
    
    xdata_B = [];
    ydata_B = [];
    
    disp([site,':',vars{j}]);
    xdata = seaf.(site).(vars{j}).Date;
    ydata = seaf.(site).(vars{j}).Data;
    
    if isfield(seaf.(site).(vars{j}),'Depth')
        sss  = find(seaf.(site).(vars{j}).Depth > -2);
        ttt  = find(seaf.(site).(vars{j}).Depth <= -2);
        if ~isempty(sss)
            xdata = [];
            ydata = [];
            xdata = seaf.(site).(vars{j}).Date(sss);
            ydata = seaf.(site).(vars{j}).Data(sss);
        end
        if ~isempty(ttt)
            
            xdata_B = seaf.(site).(vars{j}).Date(ttt);
            ydata_B = seaf.(site).(vars{j}).Data(ttt);
            
        end
        
    end
    
    %outdir = [basedir,sites{i},'/'];
    

    fig1 = figure('visible','off');
    set(fig1,'defaultTextInterpreter','latex')
    set(0,'DefaultAxesFontName','Times')
    set(0,'DefaultAxesFontSize',6)
    
    plot(xdata,ydata,'.k');hold on;
    %plot(xdata,ydata,'--','color',[0.6 0.6 0.6]);hold on;
    
    if ~isempty(ydata_B)
        plot(xdata,ydata,'.r');hold on;
        %plot(xdata,ydata,'--','color',[0.6 0.6 0.6]);hold on;
    end
    
    legend({'Surface';'Bottom'});
    
    datearray = [min(xdata):(max(xdata) - min(xdata))/5:max(xdata)];
    
    ylib = seaf.(site).(vars{j}).Variable_Name;
    
    ylabel(ylib);
    xlabel('Date');
    %title(regexprep(sites{i},'_',' '),'fontsize',10);
    
    %xlim([(min(datearray) - 10) (max(datearray) + 10)]);
    
    grid on
    
    set(gca,'xtick',datearray,'xticklabel',datestr(datearray,'dd-mm-yy'));
    
    set(gcf, 'PaperPositionMode', 'manual');
    set(gcf, 'PaperUnits', 'centimeters');
    xSize = 16;
    ySize = 8;
    xLeft = (21-xSize)/2;
    yTop = (30-ySize)/2;
    set(gcf,'paperposition',[0 0 xSize ySize])
    
    saveas(gcf,[outdir,seaf.(site).(vars{j}).Variable_ID,'.png']);
    
    txt = ['![IMage](https://github.com/AquaticEcoDynamics/csiem-data/wiki/images/summary/',agency,'/',project,'/',site,'/',seaf.(site).(vars{j}).Variable_ID,'.png "Image")'];

    fprintf(fid,'%s\n',txt);            for kkk = 1:2; fprintf(fid,'\n'); end

    close all;
end
