clear all; close all;

T = readtable("cf-standard-name-table_BB.xml");

writetable(T,'CF_Convensions.csv');