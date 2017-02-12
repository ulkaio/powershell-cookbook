##############################################################################
##
## Add-ExtendedFileProperties
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

<#

.SYNOPSIS

Add the extended file properties normally shown in Exlorer's
"File Properties" tab.

.EXAMPLE

PS > Get-ChildItem | Add-ExtendedFileProperties.ps1 | Format-Table Name,"Bit Rate"

#>

begin
{
    Set-StrictMode -Version 3

    ## Create the Shell.Application COM object that provides this
    ## functionality
    $shellObject = New-Object -Com Shell.Application
   
    ## Remember the column property mappings
    $columnMappings = @{}
}

process
{
    ## Store the property names and identifiers for all of the shell
    ## properties
    $itemProperties = @{}

    ## Get the file from the input pipeline. If it is just a filename
    ## (rather than a real file,) piping it to the Get-Item cmdlet will
    ## get the file it represents.
    $fileItem = $_ | Get-Item

    ## Don't process directories
    if($fileItem.PsIsContainer)
    {
        $fileItem
        return
    }

    ## Extract the file name and directory name
    $directoryName = $fileItem.DirectoryName
    $filename = $fileItem.Name

    ## Create the folder object and shell item from the COM object
    $folderObject = $shellObject.NameSpace($directoryName)
    $item = $folderObject.ParseName($filename)

    ## Populate the item properties
    $counter = 0
    $columnName = ""
    do
    {
        if(-not $columnMappings[$counter])
        {
            $columnMappings[$counter] = $folderObject.GetDetailsOf(
                $folderObject.Items, $counter)
        }
        
        $columnName = $columnMappings[$counter]
        if($columnName)
        {
            $itemProperties[$columnName] =
                $folderObject.GetDetailsOf($item, $counter)
        }

        $counter++
    } while($columnName)
    
    ## Process extended properties
    foreach($name in
        $item.ExtendedProperty('System.PropList.FullDetails').Split(';'))
    {
        $name = $name.Replace("*","")
        $itemProperties[$name] = $item.ExtendedProperty($name)
    }

    ## Now, go through each property and add its information as a
    ## property to the file we are about to return
    foreach($itemProperty in $itemProperties.Keys)
    {
        $value = $itemProperties[$itemProperty]
        if($value)
        {
            $fileItem | Add-Member NoteProperty $itemProperty `
                $value -ErrorAction `
                SilentlyContinue
        }
    }

    ## Finally, return the file with the extra shell information
    $fileItem
}