function outdata = append_matfiles(filepath)

filelist = dir(fullfile(filepath, '**\*.mat'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

for i = 1:length(filelist)
    disp([filelist(i).folder,'/',filelist(i).name]);
    load([filelist(i).folder,'/',filelist(i).name]);
    
    if i == 1
        outdata = swan; clear swan;
    else
        sites = fieldnames(swan);
        
        for j = 1:length(sites)
            if isfield(outdata,sites{j})
                vars = fieldnames(swan.(sites{j}));
                for k = 1:length(vars)
                    
                    if isfield(outdata.(sites{j}),vars{k})
                        
                        outdata.(sites{j}).(vars{k}).Data = [outdata.(sites{j}).(vars{k}).Data;swan.(sites{j}).(vars{k}).Data];
                        outdata.(sites{j}).(vars{k}).Date = [outdata.(sites{j}).(vars{k}).Date;swan.(sites{j}).(vars{k}).Date];
                        outdata.(sites{j}).(vars{k}).Depth = [outdata.(sites{j}).(vars{k}).Depth;swan.(sites{j}).(vars{k}).Depth];
                        outdata.(sites{j}).(vars{k}).QC = [outdata.(sites{j}).(vars{k}).QC;swan.(sites{j}).(vars{k}).QC];
                        outdata.(sites{j}).(vars{k}).Sample_Type = [outdata.(sites{j}).(vars{k}).Sample_Type;swan.(sites{j}).(vars{k}).Sample_Type];
                        outdata.(sites{j}).(vars{k}).Depth_Chx = [outdata.(sites{j}).(vars{k}).Depth_Chx;swan.(sites{j}).(vars{k}).Depth_Chx];
                        
                        
                        
                    else
                        outdata.(sites{j}).(vars{k}) = swan.(sites{j}).(vars{k});
                    end
                end
                
            else
                outdata.(sites{j}) = swan.(sites{j});
                
            end
        end
    end
end

