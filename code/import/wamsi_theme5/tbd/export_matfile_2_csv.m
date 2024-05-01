clear all; close all;

load theme5.mat;

outdir = 'V:/data-warehouse/csv/wamsi/wwmsp5/';

load ../../actions/varkey.mat;

% [snum,sstr] = xlsread('V:/data-lake/variable_key.xlsx','Key','A2:D10000');
% 
% varID = sstr(:,1);
% varName = sstr(:,2);
% varUnit = sstr(:,3);
% varSymbol = sstr(:,4);
% for i = 1:length(varSymbol)
%     if isempty(varSymbol{i})
%         varSymbol(i) = varName(i);
%     end
% end

if ~exist(outdir,'dir')
    mkdir(outdir);
end

sites = fieldnames(theme5);

% for i = 1:length(sites)
%     vars = fieldnames