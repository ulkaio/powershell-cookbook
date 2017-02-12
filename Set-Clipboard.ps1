#############################################################################
##
## Set-Clipboard
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

<#

.SYNOPSIS

Sends the given input to the Windows clipboard.

.EXAMPLE

PS > dir | Set-Clipboard
This example sends the view of a directory listing to the clipboard

.EXAMPLE

PS > Set-Clipboard "Hello World"
This example sets the clipboard to the string, "Hello World".

#>

param(
    ## The input to send to the clipboard
    [Parameter(ValueFromPipeline = $true)]
    [object[]] $InputObject
)

begin
{
    Set-StrictMode -Version 3
    $objectsToProcess = @()
}

process
{
    ## Collect everything sent to the script either through
    ## pipeline input, or direct input.
    $objectsToProcess += $inputObject
}

end
{
    ## Convert the input objects to text
    $clipText = ($objectsToProcess | Out-String -Stream) -join "`r`n"

    ## And finally set the clipboard text
    Add-Type -Assembly PresentationCore
    [Windows.Clipboard]::SetText($clipText)
}