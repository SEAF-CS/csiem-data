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

% Feb 15, 2026: tolerate date strings with or without seconds and with
% single-digit day/month/hour/minute across '-', '/', and '.' delimiters.
dateStrings = datacell{1};
if ischar(dateStrings)
    dateStrings = cellstr(dateStrings);
end
dateStrings = strtrim(dateStrings);

% Add missing seconds when timestamps are HH:MM only.
dateStrings = regexprep(dateStrings,'^(\\d{4}[-\\./]\\d{2}[-\\./]\\d{2}\\s\\d{1,2}:\\d{1,2})$','$1:00');
dateStrings = regexprep(dateStrings,'^(\\d{1,2}[-\\./]\\d{1,2}[-\\./]\\d{4}\\s\\d{1,2}:\\d{1,2})$','$1:00');

candidateFormats = {
    'yyyy-MM-dd HH:mm:ss','yyyy/MM/dd HH:mm:ss','yyyy.MM.dd HH:mm:ss',...
    'dd-MM-yyyy HH:mm:ss','dd/MM/yyyy HH:mm:ss','dd.MM.yyyy HH:mm:ss',...
    'd-M-yyyy H:m:s','d/M/yyyy H:m:s','d.M.yyyy H:m:s'};

parsed = false;
for fi = 1:length(candidateFormats)
    try
        tDate = datetime(dateStrings,'InputFormat',candidateFormats{fi},'Format','yyyy-MM-dd HH:mm:ss');
        if all(~isnat(tDate))
            mDate = datenum(tDate);
            parsed = true;
            break;
        end
    catch
    end
end

if ~parsed
    error('Failed to convert from text to date number.');
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
