function data = fix_text_as_num(sdata,sraw)

[ii,jj] = size(sdata);
data = sdata;
for i = 1:ii
    for j = 1:jj
        temp = str2double(sraw{i,j});
        if isnan(data(i,j)) & ~isnan(temp)
            data(i,j) = temp;
        end
    end
end