#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#define BUFFERSIZE 300 
#define FILEPATHROOT "/GIS_DATA/csiem-data-hub/data-lake/AIMS/temp-logger-data/"
#define SPLITDATAFOLDERNAME "SPLIT/"
#define DATAFILENAME "temp-logger-data.csv"


int main(int argc,char* argv[])
{
    FILE *FID,*CurrentWFile;
    char Header[BUFFERSIZE],Buffer[BUFFERSIZE],numstr[BUFFERSIZE];
    long int NumberofFiles,FileSizeInLines,LinesPerFile;
    int i,j;

    FID = fopen(FILEPATHROOT DATAFILENAME,"r");
    if(FID==NULL){
        printf("Issue opening temp logger data\n" FILEPATHROOT DATAFILENAME "\n");
        exit(0);
    }
    if (argc !=2)
    {
        NumberofFiles = 27;
        FileSizeInLines = 151424993;
        //  lines, words, bytes
        //  151424993,617592592,29533890365 
    }
    else
    {
        NumberofFiles = atoi(argv[1]);
        FileSizeInLines = atoi(argv[2]);
    }
    
    LinesPerFile = ceil(FileSizeInLines/NumberofFiles);

    if(fgets(Header,BUFFERSIZE,FID) == NULL)
    {printf("NO HEADER DETECTED\n");exit(0);}


    // for (i=0;i<1;i++)
    for (i=0;i<NumberofFiles;i++)
    {   
        sprintf(numstr, FILEPATHROOT SPLITDATAFOLDERNAME "%d.csv", i);
        CurrentWFile = fopen(numstr,"w");
        if (CurrentWFile == NULL){printf("Eror opening file\n");exit(0);}
        fputs(Header,CurrentWFile);

        for (j=0;j<LinesPerFile+1;j++)

        {
            if (fgets(Buffer,BUFFERSIZE,FID) == NULL){printf("fget returned NULL\n");exit(0);}
            fputs(Buffer,CurrentWFile);
        }
        fclose(CurrentWFile);
    }

    fclose(FID);
    return 0;
}