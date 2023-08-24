function plot_datafile(filename,outdir)

warning off

filename = regexprep(filename,'\','/');

tft = split(filename,'/');



fid = fopen(filename,'rt');


x  = 4;
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values
datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

data.Date = datenum(datacell{1},'dd-mm-yyyy HH:MM:SS');
data.Data = str2doubleq(datacell{3});
data.QC = datacell{4};
data.Depth = str2doubleq(datacell{2});
tdepth = datacell{2};

for i = 1:length(tdepth)
    xval = tdepth{i};
    spt = split(xval,'-');
    
    if length(spt) > 1
        
        depth1(i,1) = str2double(spt{1});
        depth2(i,1) = str2double(spt{2});
        
        try
            depth(i,1) = (depth1(i,1) + depth2(i,1)) /2;
        catch
            depth1(i,1)
            depth2(i,1)
            stop
        end
        %         if (depth2(i,1) - depth(i,1)) < 0.3
        %             data.QC(i) = {'Possible PoreWater'};
        %
        %         end
        
        
    else
        depth1(i,1) = NaN;
        depth2(i,1) = NaN;
        depth(i,1) = str2double(spt{1});
    end
end

%     data.Depth = depth;
%     data.Depth_T = depth1;
%     data.Depth_B = depth2;

headerfile = regexprep(filename,'DATA','HEADER');

headerdata = import_header(headerfile);

titlestring = regexprep(tft{end},'.csv','');
titlestring = regexprep(titlestring,'_',' ');

fig1 = figure('visible','off');
set(fig1,'defaultTextInterpreter','latex')
set(0,'DefaultAxesFontName','Times')
set(0,'DefaultAxesFontSize',6)

axes('position',[0.1 0.4 0.8 0.5]);

yyaxis left

plot(data.Date,data.Data);

xarr = [min(data.Date): (max(data.Date) - min(data.Date))/4:max(data.Date)];
xlim([min(xarr) max(xarr)]);

ylabel(headerdata.Variable_Name);

yyaxis right
plot(data.Date,data.Depth);

xarr = [min(data.Date): (max(data.Date) - min(data.Date))/4:max(data.Date)];
xlim([min(xarr) max(xarr)]);

ylabel('Depth(m)');


title(titlestring);

axes('position',[0.05 0.0 0.95 0.4]);axis off
vars = fieldnames(headerdata);
XX = 10/length(vars);

for kk = 1:length(vars)
    if kk < 14
        if ~isnumeric(headerdata.(vars{kk}))
            text(.0,1.2-(XX + (kk *0.05)),[vars{kk},': ',headerdata.(vars{kk})],'fontsize',6);
        else
            text(.0,1.2-(XX + (kk *0.05)),[vars{kk},': ',num2str(headerdata.(vars{kk}))],'fontsize',6);
        end
    else
        if ~isnumeric(headerdata.(vars{kk}))
            text(.6,1.2-(XX + ((kk-13) *0.05)),[vars{kk},': ',headerdata.(vars{kk})],'fontsize',6);
        else
            text(.6,1.2-(XX + ((kk-13) *0.05)),[vars{kk},': ',num2str(headerdata.(vars{kk}))],'fontsize',6);
        end
    end
    
end




set(gca,'XTick',xarr,'XTickLabel',datestr(xarr,'mm-yyyy'));
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperUnits', 'centimeters');
xSize = 21;
ySize = 28;
xLeft = (21-xSize)/2;
yTop = (30-ySize)/2;
set(gcf,'paperposition',[0 0 xSize ySize]);

print(gcf,[outdir,regexprep(tft{end},'.csv','.png')],'-dpng');
close all;

clear data;