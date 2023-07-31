function import_site_key


sitekey.imosbgc = read_site_sheet('IMOSBGC');
sitekey.mafrl = read_site_sheet('MAFRL');
sitekey.bom = read_site_sheet('BOM');
sitekey.dwer = read_site_sheet('DWER');
sitekey.dwermooring = read_site_sheet('DWERMOORING');
sitekey.wc = read_site_sheet('WC');

sitekey.dot = read_site_sheet('DOT');



save sitekey.mat sitekey -mat;

end
function data = read_site_sheet(sheet)

filename = '../../data-governance/site_key.xlsx';

switch sheet

    case 'MAFRL'
        [snum,sstr] = xlsread(filename,sheet,'A2:I10000');

        for i = 1:length(sstr)
            data.(sstr{i,1}).AED = sstr{i,1};
            data.(sstr{i,1}).ID = sstr{i,2};
            data.(sstr{i,1}).Description = sstr{i,3};
            data.(sstr{i,1}).Shortname = sstr{i,4};
            data.(sstr{i,1}).X = snum(i,1);
            data.(sstr{i,1}).Y = snum(i,2);
            data.(sstr{i,1}).Lat = snum(i,3);
            data.(sstr{i,1}).Lon = snum(i,4);
            data.(sstr{i,1}).Depth = snum(i,5);
        end

    case 'DWERMOORING'

        [snum,sstr] = xlsread(filename,sheet,'A2:H10000');

        for i = 1:size(sstr,1)
            data.(sstr{i,1}).AED = sstr{i,1};
            data.(sstr{i,1}).ID = snum(i,1);
            data.(sstr{i,1}).Description = sstr{i,3};
            data.(sstr{i,1}).Shortname = sstr{i,4};
            data.(sstr{i,1}).X = snum(i,4);
            data.(sstr{i,1}).Y = snum(i,5);
            data.(sstr{i,1}).Lat = snum(i,6);
            data.(sstr{i,1}).Lon = snum(i,7);
        end

    otherwise
        [snum,sstr] = xlsread(filename,sheet,'A2:H10000');

        for i = 1:size(sstr,1)
            data.(sstr{i,1}).AED = sstr{i,1};
            data.(sstr{i,1}).ID = sstr{i,2};
            data.(sstr{i,1}).Description = sstr{i,3};
            data.(sstr{i,1}).Shortname = sstr{i,4};
            data.(sstr{i,1}).X = snum(i,1);
            data.(sstr{i,1}).Y = snum(i,2);
            data.(sstr{i,1}).Lat = snum(i,3);
            data.(sstr{i,1}).Lon = snum(i,4);
        end

end


end




