fid= fopen('Coords.txt','w')
for i = 1:32
    i
    Tab = readtable([main_dir,'/Points/ghrsst_sst_point_',num2str(i),'.csv']);
    fprintf(fid,"%f,%f\n",Tab{1,2},Tab{1,3});
    Lat(i,1) = Tab{1,2};
    Lon(i,1) = Tab{1,3};
end
[Lat,Lon]
fclose(fid)