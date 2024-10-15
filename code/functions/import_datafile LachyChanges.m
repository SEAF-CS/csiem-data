function data = import_datafile(filename)

%[~,headers] = xlsread(filename,'A1:D1');

Table = readtable(filename);
DatenumVar = datenum(Table{:,1})
data.Date = DatenumVar;
data.Data = Table{:,3};
data.QC = Table{:,4};

if strcmpi(Table.Properties.VariableNames{2},'Depth')
    data.Depth = Table{:,2};
else
    data.Height = Table{:,2};
end
tdepth = Table{:,2};

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

data.Depth = depth;
data.Depth_T = depth1;
data.Depth_B = depth2;

sss = find(~isnan(depth2) == 1);
% if ~isempty(sss)
%     data.Date = [data.Date;data.Date(sss)];
%     data.Depth = [data.Depth;depth2(sss)];
%     data.Data = [data.Data;data.Data(sss)];
%     data.QC = [data.QC;data.QC(sss)];
% end
end