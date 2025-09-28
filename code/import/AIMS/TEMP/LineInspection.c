#include <stdio.h>
#include <stdlib.h>
#define BUFFERSIZE 300


int main(int argc,char* argv[])
{
    FILE* FID;
    char Buffer[BUFFERSIZE];
    int lower,upper;
    int i;

    FID = fopen("/GIS_DATA/csiem-data-hub/data-lake/AIMS/temp-logger-data/temp-logger-data.csv","r");
    lower = atoi(argv[1]);
    upper = atoi(argv[2]);

    for (i=0;i<lower;i++)
    {
        fgets(Buffer,BUFFERSIZE,FID);
    }

    for(i=lower;i<upper+1;i++)
    {
        fgets(Buffer,BUFFERSIZE,FID);
        printf("%s",Buffer);
    }
    fclose(FID);
    return 0;
}