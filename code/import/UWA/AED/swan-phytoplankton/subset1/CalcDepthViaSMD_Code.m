function depth = CalcDepthViaSMD_Code(Lat,Lon)
    run('../../../../../actions/csiem_data_paths.m')

    SummaryPath = [datapath,'csiem-data/code/actions/'];
    OrderedPaths ={ [SummaryPath,'Summary/GIS/Boundary.shp'];...
                    [SummaryPath,'Summary/GIS/external.csv'];...
                    [SummaryPath,'Summary/GIS/mesh_nodes.csv']...
                    };

    for i = 1:length(OrderedPaths)
        if ~exist(OrderedPaths{i},'file')
            error(['The file ', OrderedPaths{i},' is no longer where it was when I copied the SMD code']);
        end
    end


    shp =      shaperead(OrderedPaths{1});
    external = readtable(OrderedPaths{2});
    internal = readtable(OrderedPaths{3});

dtri_inside = DelaunayTri(internal.Var3,internal.Var4);
dtri_external = DelaunayTri(external.Var1,external.Var2);

    query_points(:,1) = Lon;
    query_points(:,2) = Lat;
    
    if inpolygon(Lon,Lat,shp(1).X,shp(1).Y)
        pt_id = nearestNeighbor(dtri_inside,query_points);
        mahd = internal.Var5(pt_id);
    else
        pt_id = nearestNeighbor(dtri_external,query_points);
        mahd = external.Var3(pt_id);
    end
    depth = -mahd;
end
