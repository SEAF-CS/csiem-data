function data = import_datafile(filename)

%[~,headers] = xlsread(filename,'A1:D1');

fid = fopen(filename,'rt');

fline = fgetl(fid);
headers = split(fline,',');

frewind(fid);



x  = 4;
textformat = [repmat('%s ',1,x)];
% read single line: number of x-values

datacell = textscan(fid,textformat,'Headerlines',1,'Delimiter',',');
fclose(fid);

% Detect whether the timestamp is stored as yyyy-mm-dd or dd-mm-yyyy (some datasets swap day and year)
dateStrings = datacell{1};
if ischar(dateStrings)
    dateStrings = cellstr(dateStrings);
end
sampleIdx = find(~cellfun(@isempty,dateStrings),1);
dateFormat = 'yyyy-mm-dd HH:MM:SS';
if ~isempty(sampleIdx)
    sample = dateStrings{sampleIdx};
    delim = '-';
    if contains(sample,'/')
        delim = '/';
    elseif contains(sample,'.')
        delim = '.';
    end
    if ~isempty(regexp(sample,['^\d{4}',delim],'once'))
        dateFormat = ['yyyy',delim,'mm',delim,'dd HH:MM:SS'];
    elseif ~isempty(regexp(sample,['^\d{2}',delim,'\d{2}',delim,'\d{4}'],'once'))
        dateFormat = ['dd',delim,'mm',delim,'yyyy HH:MM:SS'];
    end
end
try
    mDate = datenum(dateStrings,dateFormat);
catch
    % fall back to ISO layout if the heuristic fails
    mDate = datenum(dateStrings,'yyyy-mm-dd HH:MM:SS');
end
%data.Date =  datetime(datacell{1},'InputFormat','yyyy-mm-dd HH:MM:SS');
mData = str2double(datacell{3});
mQC = datacell{4};
if strcmpi(headers{2},'Depth')
    mDepth = datacell{2};
else
    mHeight = datacell{2};
end

[data.Date,ind] = sort(mDate);
data.Data = mData(ind);
data.QC = mQC(ind);
if strcmpi(headers{2},'Depth')
    data.Depth = mDepth(ind) ;
else
    data.Height = mHeight(ind);
end



% tdepth = datacell{2};

% for i = 1:length(tdepth)
%     xval = tdepth{i};
%     spt = split(xval,'-');
%     
%     if length(spt) > 1
%         
%         depth1(i,1) = str2double(spt{1});
%         depth2(i,1) = str2double(spt{2});
%         
%         try
%             depth(i,1) = (depth1(i,1) + depth2(i,1)) /2;
%         catch
%             depth1(i,1)
%             depth2(i,1)
%             stop
%         end
%         %         if (depth2(i,1) - depth(i,1)) < 0.3
%         %             data.QC(i) = {'Possible PoreWater'};
%         %
%         %         end
%         
%         
%     else
%         depth1(i,1) = NaN;
%         depth2(i,1) = NaN;
%         depth(i,1) = str2double(spt{1});
%     end
% end

% data.Depth = depth;
% data.Depth_T = depth1;
% data.Depth_B = depth2;
% 
% sss = find(~isnan(depth2) == 1);
% if ~isempty(sss)
%     data.Date = [data.Date;data.Date(sss)];
%     data.Depth = [data.Depth;depth2(sss)];
%     data.Data = [data.Data;data.Data(sss)];
%     data.QC = [data.QC;data.QC(sss)];
% end
end
