clear all; close all;

addpath(genpath('../../functions/'));

basedir = 'D:\csiem\data-lake\WAMSI\wwmsp3.1_ctd\CTD\';

filelist = dir(fullfile(basedir, '**\*.csv'));  %get list of files and folders in any subfolder
filelist = filelist(~[filelist.isdir]);  %remove folders from list

fid = fopen('Reformatted_Data.csv','wt');

fprintf(fid,'X,Y,Z,SampleID,Variable,Units,ReadingValue,VariableName,VariableType,VariableNameQualifier,AnalysisMethodCode,MeasurementInstrument,StandardUnits,LimitOfReporting,QualityCode\n');

for i = 1:length(filelist)
    
    
    
    filename = [filelist(i).folder,'\',filelist(i).name];
    
    
    disp(filename);
    
    [snum,sstr,scell] = xlsread(filename,'B4:B6');
    
    [~,~,sdates] = xlsread(filename,'B1:D1');
    
    ID = scell{1};
    X = scell{2};
    Y = scell{3};
    
    if isnumeric(ID)
        ID = num2str(ID);
    end
    
    [~,headers,~] = xlsread(filename,'A8:R8');
    headers = regexprep(headers,',','');
    
    
    data = readtable(filename, 'ReadVariableNames', false, 'HeaderLines', 8);
    
    for j = 1:length(data.Var1)
        
        if ~isnan(data.Var1(j))
            
            
            if ~isnumeric(data.Var1(j))
                thetail = char(data.Var1(j));
                thedatestr = [num2str(sdates{1}),'-',sdates{2},'-',num2str(sdates{3}),' ',thetail];
                thedate = datenum(thedatestr,'dd-mmm-yyyy HH:MM:SS');
                
            else
                thedatestr = [num2str(sdates{1}),'-',sdates{2},'-',num2str(sdates{3})];
                thedate = datenum(thedatestr,'dd-mmm-yyyy') + data.Var1(j);
            end
            
            
            
            sampleID = [datestr(thedate,'ddmmyyyy'),'_',ID];
            
            thedepth = data.Var2(j);
            
            for k = 3:length(headers)
                
                if sum(ismember(data.Properties.VariableNames,['Var',num2str(k)])) > 0
                    
                    thedata = data.(['Var',num2str(k)])(j);
                    
                    if isnumeric(thedata)
                        if ~isnan(thedata)
                            fprintf(fid,'%s,%s,%6.6f,%s,%s,To Be Added,%6.6f,%s,To Be Added,,Direct reading,Sea-Bird SBE19plus (sn01906585),To Be Added,,Excellent\n',...
                                X,Y,thedepth,sampleID,headers{k},thedata,headers{k});
                            
                        end
                    else
                        
                        newdata = thedata{1};
                        
                        newdata = regexprep(newdata,',', ' ');
                        
                        if ~isempty(newdata)
                            fprintf(fid,'%s,%s,%6.6f,%s,%s,To Be Added,%s,%s,To Be Added,,Direct reading,Sea-Bird SBE19plus (sn01906585),To Be Added,,Excellent\n',...
                                X,Y,thedepth,sampleID,headers{k},newdata,headers{k});
                            
                        end
                    end
                    
                end
            end
            
        end
    end
    
end










