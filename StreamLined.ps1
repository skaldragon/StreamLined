function StreamLined{
param(
[Parameter(Mandatory=$false,ParameterSetName="Set1")][switch]$Import,
[Parameter(Mandatory=$false,ParameterSetName="Set1")][string]$ADSName,
[Parameter(Mandatory=$false,ParameterSetName="Set1")][string]$ADSpath,
[Parameter(Mandatory=$false,ParameterSetName="Set1")][switch]$FindFile,
[Parameter(Mandatory=$false,ParameterSetName="Set1")][switch]$Exists,
[Parameter(Mandatory=$false,ParameterSetName="Set1")][switch]$AddContentfromfile,
[Parameter(Mandatory=$false,ParameterSetName="Set1")][switch]$AddContentmanually,
[Parameter(Mandatory=$false,ParameterSetName="Set1")][string]$ManualContent,
[Parameter(Mandatory=$false,ParameterSetName="Set1")][switch]$Append,
[Parameter(Mandatory=$false,ParameterSetName="Set1")][switch]$Add,
[Parameter(Mandatory=$false,ParameterSetName="Set1")][switch]$Remove,
[Parameter(Mandatory=$false,ParameterSetName="Set1")][switch]$Execute,
[Parameter(Mandatory=$false,ParameterSetName="Set1")][string]$Appendedstring

)
Add-Type -AssemblyName System.Windows.Forms
if($Import){
Write-Host "Choose your Get-Stream module File" -ForegroundColor Red
Sleep -s 3
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
$null = $FileBrowser.ShowDialog()
$Modulefile=$FileBrowser.FileName
Import-Module -Name $Modulefile
}#End Import
if (-Not (Get-Module -Name Get-stream)){
Write-Host "You cannot Continue this process until you run Run-Stream -Import" -ForegroundColor Red
    return;
}#End if

if($FindFile){
Write-Host "Checking Desktop for files you can ADS to []...." -ForegroundColor Red
$dir = [Environment]::GetFolderPath("Desktop")
gci -Path $dir | select Fullname
}


if($Exists){
$test=(get-stream -Filepath $ADSpath | select Stream).stream
    if($test -contains $ADSName){
        Write-Host "Your ADS Name already exists" -ForegroundColor Green
                                }#End if
        else{
        Write-Host "Your ADS doesn't exist" -ForegroundColor Red

            } #End else
}#End Exists
if($Add){
  Get-Stream -Filepath $ADSpath -StreamName $ADSName -AddStream 
        Sleep -s 3
$test=(get-stream -Filepath $ADSpath | select Stream).stream
    if($test -contains $ADSName){
    Write-Host "ADS Stream Added" -ForegroundColor Green

       } #END IF
    else{
    Write-Host "Couldn't Add Stream" -ForegroundColor Red
        }#End Else


}#End Add


if($AddContentfromfile){
Write-Host "Choose the file of contents you want to add, popular choices are .ps1, .bat"
Sleep -s 3
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
$null = $FileBrowser.ShowDialog()
$Modulefile=Get-Content -Path $FileBrowser.FileName
Get-Stream -Filepath $ADSpath -StreamName $ADSName -Content $Modulefile -AddStream
$viewedcontent=Get-Stream -Filepath $ADSpath -StreamName $ADSName -View
    if($viewedcontent -ne $null){
    Write-Host "Content Added" -ForegroundColor Green
    } #End If
    else{
    Write-Host "No content added" -ForegroundColor Red
        }#End Else
}#End AddContentfromfile
if($AddContentmanually){
Get-Stream -Filepath $ADSpath -StreamName $ADSName -Content $ManualContent -AddStream
$viewedcontent=Get-Stream -Filepath $ADSpath -StreamName $ADSName -View
    if($viewedcontent -ne $null){
    Write-Host "Content Added" -ForegroundColor Green
    } #End If
    else{
    Write-Host "No content added" -ForegroundColor Red
        }#End Else

}#End AddContentmanually

if($Execute){
$viewedcontent=Get-Stream -Filepath $ADSpath -StreamName $ADSName -View
if($Append){
    $viewedcontent="$viewedcontent | $Appendedstring"
    Invoke-Expression $viewedcontent
    }#End If
    else{
    Invoke-Expression $viewedcontent

    }#End Else

  

}#End Execute

if($Remove){
  Get-Stream -Filepath $ADSpath -StreamName $ADSName -Remove
        Sleep -s 3
$test=(get-stream -Filepath $ADSpath | select Stream).stream
    if($test -notcontains $ADSName){
    Write-Host "ADS Stream Removed" -ForegroundColor Green

       } #END IF
    else{
    Write-Host "Stream still exists" -ForegroundColor Red
        }#End Else
}#End Remove


}#End Streamlined
