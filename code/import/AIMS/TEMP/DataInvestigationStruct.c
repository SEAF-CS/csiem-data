#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TRUE 1
#define FALSE 0
#define BUFFERSIZE 300
#define MAXSTRINGLEN 60
#define NUMOFUNIQUE 300
#define FORMAT "%*d,%[^\t\n,],%d,%*[^,],%*d,%*[^,],%*[^,],%d,%[^\t\n,],%*[^,],%*[^,],%f,%f,%*[^,],%*[^,],%*d,%[^,],%f,%*f,%*d\n"
#define FORMAT2 "%*d,\"%[^\t\n\"]\",%d,%*[^,],%*d,%*[^,],%*[^,],%d,%[^\t\n,],%*[^,],%*[^,],%f,%f,%*[^,],%*[^,],%*d,%[^,],%f,%*f,%*d\n"
#define LINES 1000000000000000

struct SUBSITE
{
    int subsite_id;
    char subsite[MAXSTRINGLEN];
    int depth;
    float lat;
    float lon;

    int LineAppeared; 
};

struct LineData
{
    int deployment_id;
    char site[MAXSTRINGLEN];
    int site_id;
    char subsite[MAXSTRINGLEN];
    int subsite_id;
    char from_date[MAXSTRINGLEN];
    char thru_date[MAXSTRINGLEN];
    int depth;
    char parameter[MAXSTRINGLEN];
    char instrument_type[MAXSTRINGLEN];
    char serial_num[MAXSTRINGLEN];
    float lat;
    float lon;
    char gbrmpa_reef_id[MAXSTRINGLEN];
    char metadata_uuid[MAXSTRINGLEN];
    int sites_with_climatology_available;
    char time[MAXSTRINGLEN];
    float cal_val;
    float qc_val;
    int qc_flag;

    int LineAppeared;
};

char* GetString(char* start, char delim, char** RestofLine)
{   char* end;
    *RestofLine = strchr(start,delim);
    **RestofLine = '\0';
    *RestofLine = *(RestofLine)+1;
    // printf("%s\n",RestofLine);
    return start;
}

struct LineData lineparse(char Line[BUFFERSIZE], char delim)
{
    char *RestofLine,*start;
    struct LineData CurentLine;

    CurentLine.deployment_id = atoi(GetString(Line,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.site,GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.site_id = atoi(GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.subsite,GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.subsite_id = atoi(GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.from_date,GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.thru_date,GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.depth = atoi(GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.parameter,GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.instrument_type,GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.serial_num,GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.lat = atof(GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.lon = atof(GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.gbrmpa_reef_id,GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.metadata_uuid,GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.sites_with_climatology_available = atoi(GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.time,GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.cal_val = atof(GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.qc_val = atof(GetString(start,',',&RestofLine));
    start=RestofLine;
    // printf("hey\n");
    // printf("%s\n%s\n",start,RestofLine);
    start[strcspn(start, "\n")] = 0;
    CurentLine.qc_flag = atoi(start);
    return CurentLine;

}
//3660,"Green Island, Qld",902,GRESL1,2672,2007-03-30,2008-11-16,6,Water Temperature,Odyssey,SST-6320,-16.7755,145.9803,16-049,59a8c376-c853-45f9-a17a-10aec00d29bc,1,2008-06-24 20:00:00+00,22.6747,22.6747,1
struct LineData lineparse2(char Line[BUFFERSIZE], char delim)
{
    char *RestofLine,*start;
    struct LineData CurentLine;

    CurentLine.deployment_id = atoi(GetString(Line,',',&RestofLine));
    start=RestofLine;
    GetString(start,'"',&RestofLine); //this line rmeoves the first "
    start=RestofLine;
    strcpy(CurentLine.site,GetString(start,'"',&RestofLine));
    start=RestofLine;
    GetString(start,',',&RestofLine); //this line rmeoves the comma after the "
    start=RestofLine;
    CurentLine.site_id = atoi(GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.subsite,GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.subsite_id = atoi(GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.from_date,GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.thru_date,GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.depth = atoi(GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.parameter,GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.instrument_type,GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.serial_num,GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.lat = atof(GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.lon = atof(GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.gbrmpa_reef_id,GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.metadata_uuid,GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.sites_with_climatology_available = atoi(GetString(start,',',&RestofLine));
    start=RestofLine;
    strcpy(CurentLine.time,GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.cal_val = atof(GetString(start,',',&RestofLine));
    start=RestofLine;
    CurentLine.qc_val = atof(GetString(start,',',&RestofLine));
    start=RestofLine;
    // printf("hey\n");
    // printf("%s\n%s\n",start,RestofLine);
    start[strcspn(start, "\n")] = 0;
    CurentLine.qc_flag = atoi(start);
    return CurentLine;

}
void PrintLINESTRUCT(struct LineData Line)
{
    printf("%d;%s;%d;%s;%d;%s;%s;%d;%s;%s;%s;%f;%f;%s;%s;%d;%s;%f;%f;%d\n",Line.deployment_id,Line.site,Line.site_id,Line.subsite,Line.subsite_id,Line.from_date,Line.thru_date,Line.depth,Line.parameter,Line.instrument_type,Line.serial_num,Line.lat,Line.lon,Line.gbrmpa_reef_id,Line.metadata_uuid,Line.sites_with_climatology_available,Line.time,Line.cal_val,Line.qc_val,Line.qc_flag);
}

void PrintRelevantLineStruct(struct LineData Line)
{
    printf("%s,%d,%d\n",Line.site,Line.site_id,Line.LineAppeared);

}

int CheckIfSiteUnique(struct LineData *List, int ListLength, struct LineData Item)
{
    int i,unique = TRUE;

    for(i=0;i<ListLength;i++)
    {
        if (List[i].site_id == Item.site_id)
        {unique = FALSE;}
    }
    return unique;
}
int checkIfSubsiteIsUnique(struct SUBSITE *SubsiteList,int NumOfSubsites,struct SUBSITE curentSubsite)
{
    int i,unique = TRUE;
    for (i=0;i<NumOfSubsites;i++)
    {
        if (curentSubsite.subsite_id == SubsiteList[i].subsite_id)
        {unique= FALSE;}
    }
    return unique;
}

int findUniqueSiteIndex(struct LineData *List, int ListLength, struct LineData Item)
{
    int Index=-1,i;
    for(i=0;i<ListLength;i++)
    {
        // if (strcmp((List[i].site),Item.site)==0)
        if (List[i].site_id == Item.site_id)
        {Index = i;}
    }
    if (Index == -1){printf("Index not found\n");}
    return Index;
}

void PrintSUBSITEList(struct SUBSITE thesubsite)
{
    printf("\t%s,%d,%d,%f,%f,%d\n",thesubsite.subsite,thesubsite.subsite_id,thesubsite.depth,thesubsite.lat,thesubsite.lon,thesubsite.LineAppeared);
}





int main()
{
    FILE* FID;
    char Buffer[BUFFERSIZE],BackupBuffer[BUFFERSIZE];
    struct LineData UniqueSites[NUMOFUNIQUE],CurentLine;
    int totSites=0,SiteLineNumber[NUMOFUNIQUE];
    int unique,NumOfScanned;
    struct SUBSITE currentsubsite;
    struct SUBSITE *subsiteList;
    struct SUBSITE **subsiteListOfLists;
    int *NumberofSubsites;
    int currentSiteIndex;


    int i,j;
    int dataleft = TRUE;
    int n = 2;


    subsiteListOfLists = (struct SUBSITE**)malloc(sizeof(struct SUBSITE*)*NUMOFUNIQUE);
    NumberofSubsites = (int*)malloc(sizeof(int)*NUMOFUNIQUE);
    for (i=0;i<NUMOFUNIQUE;i++){NumberofSubsites[i]=0;}
    

    FID = fopen("/GIS_DATA/csiem-data-hub/data-lake/AIMS/temp-logger-data/temp-logger-data.csv","r");
    if(FID == NULL)
    {
        printf("Issue opening temp logger data file\n");
        exit(0);
    }
    // move the file point past the headers
    fgets(Buffer,BUFFERSIZE,FID);

    do
    {
        if(fgets(Buffer,BUFFERSIZE,FID) == NULL)
        {
            dataleft = FALSE;
            break;
        }
        

        strcpy(BackupBuffer,Buffer);
        CurentLine = lineparse(Buffer,',');

            if (CurentLine.site[0] == '"')
                {
                    CurentLine = lineparse2(BackupBuffer,',');
                }    
                // There is a site called "Green Island, Qld" with the quotation marks, which messes us csv format
                // Hence the exception is dealt with here

// "Water Temperature"
        if (strcmp(CurentLine.parameter,"Water Temperature") != 0)
        {
            printf("Not good\n");
            printf("|%s|\n|%s|\n",CurentLine.parameter,"Water Temperature");
            break;
        }
        unique = CheckIfSiteUnique(UniqueSites,totSites,CurentLine);
        if (unique == TRUE)
        {
            // printf("Made it here\n");
            // printf("site:%s,siteid:%d,depth:%d,varname:%s,lat:%f,lon:%f,time:%s,val:%f\n",site,siteid,depth,varname,lat,lon,time,val);
            // printf("sites:%d,Vars%d\n",totSites,totVars);
            // Adding all site data to Arrays
            CurentLine.LineAppeared = n;
            UniqueSites[totSites] = CurentLine;

            // malloc this unique site's subsite list.
            subsiteListOfLists[totSites] = (struct SUBSITE*)malloc(sizeof(struct SUBSITE)*NUMOFUNIQUE);
            totSites = totSites+1;
        }

        // Check which SITE we are playing with
        currentSiteIndex = findUniqueSiteIndex(UniqueSites,totSites,CurentLine);

        currentsubsite.subsite_id = CurentLine.subsite_id;
        strcpy(currentsubsite.subsite,CurentLine.subsite);
        currentsubsite.depth = CurentLine.depth;
        currentsubsite.lat = CurentLine.lat;
        currentsubsite.lon = CurentLine.lon;
        currentsubsite.LineAppeared = n;

        unique = checkIfSubsiteIsUnique(subsiteListOfLists[currentSiteIndex],NumberofSubsites[currentSiteIndex],currentsubsite);

        if (unique== TRUE)
        {
            subsiteListOfLists[currentSiteIndex][(NumberofSubsites[currentSiteIndex])] = currentsubsite;
            NumberofSubsites[currentSiteIndex]++;
        }
       

        // unique = CheckIfStringUnique(VarArray,totVars,varname);
        // if (unique == TRUE)
        // {
        //     // printf("Made it here\n");
        //     strcpy(VarArray+totVars*MAXSTRINGLEN,varname);
        //     totVars = totVars+1;
        // }

        // if (NUMOFUNIQUE<=1+totSites)
        // {printf("ended early\nTo many sites\n");break;}
        // if(NUMOFUNIQUE<=1+totVars)
        // {printf("ended early\nTo many vars\n");break;}
        if (n==LINES)
        {printf("ended early\nTo many lines\n");break;}
        n+=1;

    } while (dataleft == TRUE);


    //printf("site,site_id,depth,lat,lon,LineAppeared\n");
    for (i=0;i<totSites;i++)
    {
        PrintRelevantLineStruct(UniqueSites[i]);
        // PrintLINESTRUCT(UniqueSites[i]);
        for(j=0;j<NumberofSubsites[i];j++)
        {
            PrintSUBSITEList(subsiteListOfLists[i][j]);
        }

        //PrintLINESTRUCT(UniqueSites[i]);
    }

    // printf("\n");
    //   for (i=0;i<totVars;i++)
    // {
    //     printf("%s\n",VarArray+i*MAXSTRINGLEN);
    // }


    
    fclose(FID);
    for (i = 0; i<totSites;i++)
        {free(subsiteListOfLists[i]);}
    free(subsiteListOfLists);
    free(NumberofSubsites);
    return 0;
}

