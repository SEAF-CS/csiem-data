clear all; close all;

addpath(genpath('../../functions/'));

load ../../actions/agency.mat;
load ../../actions/varkey.mat;

data = readtable(files(fileidx).name, 'ReadVariableNames', false, 'HeaderLines', 1);  
