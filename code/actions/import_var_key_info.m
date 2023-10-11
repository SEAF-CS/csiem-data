clear all; close all;

filename = '../../data-governance/variable_key.xlsx';

[snum,sstr] = xlsread(filename,'MASTER KEY','A2:J10000');

st = length(sstr) + 1;

thearray = ['J2:J',num2str(st)];

[~,~,scell] = xlsread(filename,'MASTER KEY',thearray);
for i = 1:length(scell)
    varCFConv(i,1) = scell{i,1};
end

varID = sstr(:,1);
varName = sstr(:,2);
varUnit = sstr(:,3);
varSymbol = sstr(:,4);
varLaTexUnit = sstr(:,5);
varProg = sstr(:,6);
varSH = sstr(:,7);
varCF = sstr(:,8);
varCF_Unit = sstr(:,9);
for i = 1:length(varSymbol)
    if isempty(varSymbol{i})
        varSymbol(i) = varUnit(i);
    end
end

[snum,sstr] = xlsread(filename,'Model_TFV','A2:F10000');

tfvID = sstr(:,1);
tfvName = sstr(:,4);
tfvUnits = sstr(:,5);
tfvConv = snum(:,4);


for i = 1:length(varID)
    
    varkey.(varID{i}).Name = varName{i};
    varkey.(varID{i}).Unit = varUnit{i};
    varkey.(varID{i}).LaTexUnit = varLaTexUnit{i};
    varkey.(varID{i}).SH = varSH{i};
    varkey.(varID{i}).Symbol = varSymbol{i};
    varkey.(varID{i}).Programmatic = varProg{i};
    varkey.(varID{i}).CF = varCF{i};
    varkey.(varID{i}).CFUnit = varCF_Unit{i};
    varkey.(varID{i}).CFConv = varCFConv(i);
    
    sss = find(strcmpi(tfvID,varID{i}) == 1);
    if ~isempty(sss)
        varkey.(varID{i}).tfvName = tfvName{sss};
        varkey.(varID{i}).tfvUnits = tfvUnits{sss};
        varkey.(varID{i}).tfvConv = tfvConv(sss);
    else
        varkey.(varID{i}).tfvName = '';
        varkey.(varID{i}).tfvUnits = '';
        varkey.(varID{i}).tfvConv = NaN;
    end
end

save varkey.mat varkey -mat;


agency.theme5 = import_agency_conv('THEME5');
agency.theme2light = import_agency_conv('THEME2LIGHT');

agency.theme5met = import_agency_conv('THEME5MET');

agency.dot = import_agency_conv('DOT');
agency.bom = import_agency_conv('BOM');
agency.dwer = import_agency_conv('DWER');
agency.dwermooring = import_agency_conv('DWERMOORING');
agency.mafrl = import_agency_conv('MAFRL');
agency.imosbgc = import_agency_conv('IMOSBGC');
agency.imosprofile = import_agency_conv('IMOSPROFILE');

save agency.mat agency -mat;





    




