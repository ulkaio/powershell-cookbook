##############################################################################
##
## Add-FormatData
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

<#

.SYNOPSIS

Adds a table formatting definition for the specified type name.

.EXAMPLE

PS > $r = [PSCustomObject] @{
    Name = "Lee";
    Phone = "555-1212";
    SSN = "123-12-1212"
}
PS > $r.PSTypeNames.Add("AddressRecord")
PS > Add-FormatData -TypeName AddressRecord -TableColumns Name, Phone
PS > $r

Name Phone
---- -----
Lee  555-1212

#>

param(
    ## The type name (or PSTypeName) that the table definition should
    ## apply to.
    $TypeName,

    ## The columns to be displayed by default
    [string[]] $TableColumns
)

Set-StrictMode -Version 3

## Define the columns within a table control row
$rowDefinition = New-Object Management.Automation.TableControlRow

## Create left-aligned columns for each provided column name
foreach($column in $TableColumns)
{
    $rowDefinition.Columns.Add(
	    (New-Object Management.Automation.TableControlColumn "Left", 
            (New-Object Management.Automation.DisplayEntry $column,"Property")))
}

$tableControl = New-Object Management.Automation.TableControl
$tableControl.Rows.Add($rowDefinition)

## And then assign the table control to a new format view,
## which we then add to an extended type definition. Define this view for the
## supplied custom type name.
$formatViewDefinition = New-Object Management.Automation.FormatViewDefinition "TableView",$tableControl
$extendedTypeDefinition = New-Object Management.Automation.ExtendedTypeDefinition $TypeName
$extendedTypeDefinition.FormatViewDefinition.Add($formatViewDefinition)

## Add the definition to the session, and refresh the format data
[Runspace]::DefaultRunspace.InitialSessionState.Formats.Add($extendedTypeDefinition)
Update-FormatData