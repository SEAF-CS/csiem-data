clear all;

tic

data = parquetread('D:\csiem\data-warehouse\parq\wamsi\wwmsp5\20220503_CS4_CTD_209850_EPSG7844_Conductivity_DATA.parquet');

toc

tic
data = readtable('D:\csiem\data-warehouse\csv\wamsi\wwmsp5\20220503_CS4_CTD_209850_EPSG7844_Conductivity_DATA.csv');
toc