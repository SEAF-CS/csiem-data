def Main():
    Bucket = 'wamsi-westport-project-1-1'
    FilePaths = ['csiem-data/data-lake/UKMO/',\
                 'csiem-data/data-lake/NASA/',\
                 'csiem-data/data-lake/MOI/',\
                 'csiem-data/data-lake/ESA/',\
                ]

    # Destinations = ['/GIS_DATA/csiem-data-hub/data-lake/UKMO/',\
    #                 '/GIS_DATA/csiem-data-hub/data-lake/NASA/',\
    #                 '/GIS_DATA/csiem-data-hub/data-lake/MOI/',\
    #                 '/GIS_DATA/csiem-data-hub/data-lake/ESA/',\
    #                 ]

    RootPath = GetCsiemDataPath()
    Destinations = [RootPath+'data-lake/UKMO/',\
                    RootPath+'data-lake/NASA/',\
                    RootPath+'data-lake/MOI/',\
                    RootPath+'data-lake/ESA/',\
                    ]    
    for i in range(len(FilePaths)):
        TransferFolder(Bucket,FilePaths[i],Destinations[i])

    import os
    os.mkdir(RootPath+'data-lake/NASA/GHRSST/ghrsst/')
    os.rename(RootPath+'data-lake/NASA/GHRSST/Points/',RootPath+'data-lake/NASA/GHRSST/ghrsst/Points/')
    os.rename(RootPath+'data-lake/NASA/GHRSST/Polygon_nearshore/',RootPath+'data-lake/NASA/GHRSST/ghrsst/Polygon_nearshore/')
    os.rename(RootPath+'data-lake/NASA/GHRSST/Polygon_offshore/',RootPath+'data-lake/NASA/GHRSST/ghrsst/Polygon_offshore/')

    os.rename(RootPath+'data-lake/UKMO/OSTIA/Temperature/',RootPath+'data-lake/UKMO/OSTIA/temperature/')
    import sys
    sys.path.append('../UKMO/')
    import ImportUKMO as UKMO  
    DataOutPath = RootPath+'data-warehouse/csv/ukmo/'
    DataLocation = RootPath+'data-lake/UKMO/'
    MatFilePath = RootPath+'csiem-data/code/actions/'
    AgencySheetName = 'UKMO'

    UKMO.Main(DataOutPath,DataLocation,MatFilePath,AgencySheetName)

def GetCsiemDataPath():
    # csiem-data/code/import/GenericS3Bucket/ImportS3BucketIntoDavy.py
    # csiem-data/code/actions/csiem_data_paths.m
    filepath = '../../actions/csiem_data_paths.m'
    f = open(filepath,'r')
    TextFileContents = f.read()

    for item in TextFileContents.split("\n"):
        if 'datapath' in item:
            # As of 31/05/2024 this is the structure of the matlab file
            # datapath = '/GIS_DATA/csiem-data-hub/';
            
            # This splits the string into 3, grabbing the middle part gives the path
            temp = item.split("'")
            Path = temp[1]
            break
    f.close()
    return Path

def TransferFolder(HostBucketName,HostFolderPath,DesitinationFolderPath):
    """"This function takes in s3 Bucket name and s3 folder name downloads
    the contents of the folder and puts it into the folder DesitionationFolderpath
    
    Example:
    This is the folder on the s3 Bucket, wamsi-westport-project-1-1.
    csiem-data/data-lake/UKMO/
    the contents will be downloaded and put into destination folder.
    /GIS_DATA/csiem-data-hub/data-lake/UKMO/
    """
    import sys
    sys.path.append('./')
    import boto3
    import os
    from CredsFile import Creds 

    (Id,Key) = Creds()
    # Create a boto3 session
    session = boto3.Session(
        aws_access_key_id=Id,
        aws_secret_access_key=Key,
    )

    s3 = session.resource('s3', endpoint_url='https://projects.pawsey.org.au')
    BucketStruct = s3.Bucket(HostBucketName)    
    
    print(f'Transporting:{HostBucketName},{HostFolderPath}')
    for file in BucketStruct.objects.filter(Prefix=HostFolderPath):
        # The download command throws an error if a folder is passed
        # this checks if "file" is a folder
        if file.key[-1] == '/':
            continue
        relativeFilepath = remove_prefix(file.key,HostFolderPath)
        outputfilename = DesitinationFolderPath + relativeFilepath
        outputfilefolder = FindFolder(outputfilename)
     
        if os.path.exists(outputfilefolder) == True:
            pass
        else:
            os.makedirs(outputfilefolder)
        print(f'    Filename: {outputfilename}')
        BucketStruct.download_file(Key=file.key,Filename=outputfilename)
        
 

def FindFolder(filepathstr):
    nChars = len(filepathstr)
    for charIndex in range(nChars-1,0-1,-1):
        if filepathstr[charIndex] == '/':
            return filepathstr[0:charIndex+1]

def remove_prefix(text, prefix):
    if text.startswith(prefix):
        return text[len(prefix):]
    return text


if __name__ == "__main__":
    Main()