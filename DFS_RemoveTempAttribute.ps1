#  Script name:   DFS_RemoveTempAttribute.ps1
#  Version:       1.0
#  Created on:    08/12/2017
#  Author:        Ted Henley
#  Purpose:       Reiterates through directories removing the temporary attribute.  Overcomes 260 character limit.
#                 
#  History:   

$DirectoryRoot = "D:\Users\Ted\Documents\" #Read-Host "Please enter root directory to start from"
if($DirectoryRoot  -eq ""){
    Write-Error "No root directory selected.  Exiting script."
    Exit 1
}

Function findChildFolders($ParentFolder){
    [array]$AllChildren = $ParentFolder
    $Directories = Get-ChildItem -Path $ParentFolder -Directory
    foreach($Directory in $Directories){  
        $AllChildren += $Directory.FullName.ToString()
        findChildFolders($Directory.FullName.ToString())
    }
    Return $AllChildren
}

Function removeTemporaryAttribute($DirectoryPath){
    New-PSDrive -name X -psprovider FileSystem -root $DirectoryPath
    $files = get-childitem X:\ -File
    ForEach($file in $files){
        if (($file.attributes -band 0x100) -eq 0x100){
            $file.attributes = ($file.attributes -band 0xFEFF)
            Write-Host "File updated"
        }
    }
}

$AllFolders = findChildFolders($DirectoryRoot)
foreach($Folder in $AllFolders){    
    removeTemporaryAttribute($Folder)
}