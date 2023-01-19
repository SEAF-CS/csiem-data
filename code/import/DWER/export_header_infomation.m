function export_header_infomation

filepath = 'V:/data-warehouse/csv//';

filelist = dir(fullfile(filepath, '**\*HEADER.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

fid = fopen('Site_Header_Data.csv','wt');
fprintf(fid,'Agency Name,Agency Code,Program,Project,Station Status,Lat,Long,Time Zone,Vertical Datum,National Station ID,Site Description,Contact Email,Data Classification\n');

sitelist = [];

for i = 1:length(filelist)
    filename = [filelist(i).folder,'/',filelist(i).name];
    data = import_header(filename);
    
    %alldata(i).data = data;
    
    sss = find(strcmpi(sitelist,data.National_Station_ID) == 1);
    
    if isempty(sss)
        data.National_Station_ID
        sitelist = [sitelist;{data.National_Station_ID}];
        
        fprintf(fid,'%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s\n',...
            data.Agency_Name,data.Agency_Code,data.Program,data.Station_Status,data.Project,...
            data.Lat,data.Long,data.Time_Zone,data.Vertical_Datum,data.National_Station_ID,...
            data.Site_Description,data.Contact_Email,data.Data_Classification);
    end
end
fclose(fid);
        
        
    

%save alldata.mat alldata -mat;





end

function data = import_header(filename)

fid = fopen(filename,'rt');

while ~feof(fid)
    fline = fgetl(fid);
    %fline
    spt = split(fline,',');
    header = regexprep(spt{1},' ','_');
    header = regexprep(header,'-','_');
    sheader = split(header,'(');
    data.(sheader{1}) = spt{2};
end
fclose(fid);
end