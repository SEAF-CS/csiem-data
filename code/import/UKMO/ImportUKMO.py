def Main(OutPutFolderPath,PathToDataFolder,MatFilePath,AgencyNameinAgency):
    import pandas as pd
    import os
    import scipy.io
    import shutil

    if os.path.exists(OutPutFolderPath) == True:
        shutil.rmtree(OutPutFolderPath)
        os.makedirs(OutPutFolderPath)
        pass
    else:
        os.makedirs(OutPutFolderPath)

    varkeyPath = MatFilePath+'varkey.mat'
    agencyPath = MatFilePath+'agency.mat'

    varkey = scipy.io.loadmat(varkeyPath)['varkey']
    FullVarIdList = varkey.dtype.names

    agency = scipy.io.loadmat(agencyPath,struct_as_record=True)['agency']
    agencyNum = FindinList(AgencyNameinAgency,agency.dtype.names)
    agency = agency[0][0][agencyNum]

    VarIDList = []
    FileHeadersList =[]
    for i in range(len(agency[0][0])):
        tempFileHeader = agency[0][0][i][0][0][0]
        tempVarID =      agency[0][0][i][0][0][1]
        FileHeadersList.append(tempFileHeader)
        VarIDList.append(tempVarID)

    print('Importing UKMO files')
    for root, subdirs, files in os.walk(PathToDataFolder,topdown=False):
        if 'Polygon' in root:
            pass
            # This is the code to handle the polygon files without lat and longs
        else:
            for filename in files:
                if '.md' in filename:
                    continue
                file_path = os.path.join(root, filename)                
                print('\tWorking on file: %s)' % (file_path))

                Table = pd.read_table(file_path, delimiter=',')
                
                col = 3
                FileHeader = Table.axes[1][col]
                HeaderIndex = FindinList(FileHeader,FileHeadersList)

                VarID = VarIDList[HeaderIndex]
                VarIndex = FindinList(VarID,FullVarIdList)
                VarName = varkey[0][0][VarIndex][0][0][0][0]

                # Converting Kelvin into Celcius
                Table.iloc[:,3] = Table.iloc[:,3]-273.15

                FileNamesTuple = FileNameCreator(OutPutFolderPath,filename,VarName)
                if os.path.exists(FileNamesTuple[0]):
                    pass
                else:
                    with open(FileNamesTuple[0],'w') as f:
                        f.write('Date,Depth,Data,QC\n')
                    with open(FileNamesTuple[1],'w') as f:
                        f.write('Agency Name,United Kingdom Met Office\n')
                    
                        f.write('Agency Code,UKMO\n')
                        f.write('Program,Global Ocean OSTIA Sea Surface Temperature and Sea Ice Analysis\n')
                        f.write('Project,Operational Sea surface Temperature and Ice Analysis (OSTIA)\n')
                        f.write('Tag,UKMO-OSTIA\n')
                        
                        f.write(f'Data File Name,{FileNamesTuple[0]}\n')
                        f.write('Location,N/A\n')
                        
                        f.write('Station Status,\n')
                        f.write(f'Lat,{Table.iloc[0,1]:6.9}\n')
                        f.write(f'Long,{Table.iloc[0,2]:6.9}\n')
                        f.write('Time Zone,GMT +8\n')
                        f.write('Vertical Datum,mAHD\n')
                        f.write('National Station ID,N/A\n')
                        
                        f.write('Site Description,\n')
                        f.write('Deployment,Satelite\n')        
                        f.write('Deployment Position,0m below surface\n')
                        f.write('Vertical Reference,m below surface\n')
                        f.write('Site Mean Depth,\n')
                        
                        f.write('Bad or Unavailable Data Value,NaN\n')
                        f.write('Contact Email, Lachy Gill, uwa email:00114282@uwa.edu.au 05/04/2024\n')
                        
                        f.write(f'Variable ID,{VarID[0]}\n')
                        
                    
                        f.write('Data Category,\n')
                    
                        f.write('Sampling Rate (min),\n') #%4.4f\n',SD * (60*24))
                        f.write('Date,yyyy-mm-dd HH:MM:SS\n')
                        f.write('Depth,Decimal\n')
                        f.write(f'Variable,{VarName}\n')
                        f.write('QC,String\n')

                with open(FileNamesTuple[0],'a') as f:
                    time = Table.iloc[:,0]
                    temp = Table.iloc[:,3]
                    for i in range(len(time)):
                        # We want the time in form yyyy-mm-dd HH:MM:SS
                        # we arent given HH:MM:SS so im adding 00:00:00
                        # depth is also 0 because it is surface temp
                        f.write(f'{time[i]} 00:00:00,0,{temp[i]},N\n')  



def FileNameCreator(OutPutFolderPath,filename,Varname):
    OutputNameSiteSignifier = 'Site_'
    SiteNum = SiteNumberExtractor(filename)
    SiteStr = OutputNameSiteSignifier+SiteNum
    Varname = Varname.replace(' ','_')
    base = f'{OutPutFolderPath}{Varname}_{SiteStr}'
    filetype = '.csv'
    data=base+'_DATA'+filetype
    header=base+'_HEADER'+filetype
    return (data,header)

    
def SiteNumberExtractor(filename):
    sitePrefix = '_point_'
    siteSuffix = '.csv'
    Startind = filename.find(sitePrefix)
    Endind = filename.find(siteSuffix)
    n = len(sitePrefix)
    siteNum = filename[Startind+n:Endind]
    return siteNum

def FindinList(Item,List):
    index = 0
    for name in List:
        if name == Item:
            return index
        else:
            index = index+1
    raise Exception('Not in list')

if __name__ == '__main__':
    # This Section for is if the code is called directly, the purpose of this file is to be called from TransportS3Bucket code or standalone to import just UKMO.

    # These few lines are to grab the function from another python file
    # ----------------------------------
    import sys
    sys.path.append('../TransportS3BucketIntoDataLake/')
    import TransportS3BucketIntoDataLake as LakeTransport
    # ----------------------------------

    RootPath = LakeTransport.GetCsiemDataPath()
    DataOutPath = RootPath+'data-warehouse/csv/ukmo/'
    DataLocation = RootPath+'data-lake/UKMO/'
    MatFilePath = RootPath+'csiem-data/code/actions/'
    AgencySheetName = 'UKMO'

    PathInBucket = 'csiem-data/data-lake/UKMO/'
    Destinations = RootPath+'data-lake/UKMO/'
    Bucket = 'wamsi-westport-project-1-1'
    LakeTransport.TransferFolder(Bucket,PathInBucket,Destinations)
    Main(DataOutPath,DataLocation,MatFilePath,AgencySheetName)
