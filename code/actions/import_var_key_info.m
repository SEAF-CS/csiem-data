clear all; close all;
csiem_data_paths
filename = '../../data-governance/variable_key.xlsx';


[snum,sstr] = xlsread(filename,'MASTER KEY','A2:K10000');

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
varCategory = sstr(:,11);
for i = 1:length(varSymbol)
    if isempty(varSymbol{i})
        varSymbol(i) = varUnit(i);
    end
end

[snum,sstr] = xlsread(filename,'Model_TFV','A2:H10000');

tfvID = sstr(:,1);
tfvName = sstr(:,4);
tfvUnits = sstr(:,5);
tfvConv = snum(:,6);
marvlID = snum(:,8);



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
    varkey.(varID{i}).Category = varCategory{i};
    sss = find(strcmpi(tfvID,varID{i}) == 1);
    if ~isempty(sss)
        varkey.(varID{i}).tfvName = tfvName{sss};
        varkey.(varID{i}).tfvUnits = tfvUnits{sss};
        varkey.(varID{i}).tfvConv = tfvConv(sss);
        varkey.(varID{i}).marvlID = marvlID(sss);
    else
        varkey.(varID{i}).tfvName = 'N/A';
        varkey.(varID{i}).tfvUnits = 'N/A';
        varkey.(varID{i}).tfvConv = NaN;
        varkey.(varID{i}).marvlID = marvlID(sss);
    end
end

save varkey.mat varkey -mat;


agency.wwmsp1 = import_agency_conv('WWMSP1');
    % agency.wwmsp1wrf = import_agency_conv('WWMSP1.1-WRF');

agency.wwmsp2 = import_agency_conv('WWMSP2');
    % agency.theme2light = import_agency_conv('THEME2LIGHT');
    % THEME2.2
    % Theme2SGPAR

agency.wwmsp3 = import_agency_conv('WWMSP3');
    % agency.theme3ctd = import_agency_conv('THEME3CTD');
    % agency.theme3sedpsd = import_agency_conv('WWMSP3SEDPSD'); %these two have same vars
    % agency.theme3sgrest = import_agency_conv('WWMSP3SGREST'); %these two have same vars
    % agency.WWMSP31SedimentDeposition = import_agency_conv('WWMSP3.1-Sediment-Deposition');
    % added wamsi 3.3 porewater variables

agency.wwmsp4 = import_agency_conv("WWMSP4");

agency.wwmsp5 = import_agency_conv('WWMSP5');
    %This now contains:
    % agency.theme5 = import_agency_conv('THEME5');
    % agency.theme5met = import_agency_conv('THEME5MET');
    % agency.theme5waves = import_agency_conv('WWMSP5Waves');
    % agency.theme51waves = import_agency_conv('WWMSP5.1Waves');
    % WWMSP5 ROMS

agency.WCWA = import_agency_conv('WCWA');
    % composed of two
    %WC_BMT
    %WCWA which was used in WCWA/import_PhyWQ_1334_09
    
agency.dot = import_agency_conv('DOT');
agency.bom = import_agency_conv('BOM');
    %contains
    % agency.bombarraftv = import_agency_conv('BOM-BARRA');
    % idy

agency.dwer = import_agency_conv('DWER');
    % This has 2 sheets in one
    % agency.dwermooring = import_agency_conv('DWERMOORING');
    % agency.dwer = import_agency_conv('DWER');

agency.IMOS = import_agency_conv('IMOS');
    % The following have been compressed into one:
    % agency.imosbgc = import_agency_conv('IMOSBGC');
    % agency.imossrs = import_agency_conv('IMOSSRS');
        % there are 3 import codes for imossrs and they produced massive files
    % agency.imosprofile = import_agency_conv('IMOSPROFILE');

agency.fpa = import_agency_conv('FPA');
    % agency.fpamqmp = import_agency_conv('FPA-MQMP');
    % There was also fpa_bmt in the var key 

agency.bmtswan = import_agency_conv('BMT-SWAN');

agency.UKMO = import_agency_conv('UKMO');
agency.NASA = import_agency_conv('NASA');

agency.aims = import_agency_conv('AIMS');
agency.mafrl = import_agency_conv('MAFRL');

agency.DWER_Phytoplankton = import_agency_conv('DWER Phytoplankton');
agency.DWER_PhytoplanktonGroups = import_agency_conv('DWERPhytoPlanktonGroups');
agency.IMOS_Phytoplankton = import_agency_conv('IMOS Phytonplakton');
agency.IMOS_PhytoplanktonGroup = import_agency_conv('IMOSPhytoGroups');
agency.WCWA1_PhytoplanktonSpecies = import_agency_conv("WCWA PhytoplanktonSpecies");
agency.WCWA1_PhytoplanktonGroup = import_agency_conv("WCWA PhytoplanktonGroup");
agency.WCWA2_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species2");
agency.WCWA2_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Group2");
agency.WCWA3_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species3");
agency.WCWA3_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups3");
agency.WCWA4_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species4");
agency.WCWA4_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups4");
agency.WCWA5_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species5");
agency.WCWA5_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups5");
agency.WCWA6_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species6");
agency.WCWA6_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups6");
agency.WCWA7_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species7");
agency.WCWA7_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups7");
agency.WCWA8_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups8");
agency.WCWA8_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species8");
agency.WCWA9_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups9");
agency.WCWA9_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species9");

agency.WCWA10_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups10");
agency.WCWA10_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species10");

agency.WCWA16_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups16");
agency.WCWA16_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species16"); 

agency.WCWA23_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups23");
agency.WCWA23_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species23");

agency.WCWA29_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups29");
agency.WCWA29_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species29");

agency.WCWA30_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups30");
agency.WCWA30_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species30");

agency.WCWA31_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups31");
agency.WCWA31_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species31");

agency.WCWA32_PhytoplanktonGroup = import_agency_conv("WCWA Phyto Groups32");
agency.WCWA32_PhytoplanktonSpecies = import_agency_conv("WCWA Phyto Species32");

agency.SWANESTGroups = import_agency_conv("SWANEST Groups");
agency.SWANESTSpecies = import_agency_conv("SWANEST Species");
agency.UWA_AED_PHY_1_Species = import_agency_conv("UWA_AED_PHY_1_Species");
agency.UWA_AED_PHY_1_Group = import_agency_conv("UWA_AED_PHY_1_Group");
agency.UWA_AED_PHY_2_Species = import_agency_conv("UWA_AED_PHY_2_Species");
agency.UWA_AED_PHY_2_Group = import_agency_conv("UWA_AED_PHY_2_Group");

agency.MOI = import_agency_conv('MOI');
agency.ESA = import_agency_conv('ESA');

agency.DEP = import_agency_conv('DEP');
agency.UWA = import_agency_conv('UWA');
agency.CSIRO = import_agency_conv('CSIRO');

save agency.mat agency -mat;





    




