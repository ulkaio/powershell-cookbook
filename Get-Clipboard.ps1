#############################################################################
##
## Get-Clipboard
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

<#

.SYNOPSIS

Retrieve the text contents of the Windows Clipboard.

.EXAMPLE

PS > Get-Clipboard
Hello World

#>

Set-StrictMode -Version 3

Add-Type -Assembly PresentationCore
[Windows.Clipboard]::GetText()