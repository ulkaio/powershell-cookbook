##############################################################################
##
## Get-OfficialTime
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

<#

.SYNOPSIS

Gets the official US time (PST) from time.gov

#>

Set-StrictMode -Version 3

## Create the URL that contains the Twitter search results
Add-Type -Assembly System.Web
$url = 'http://www.time.gov/timezone.cgi?Pacific/d/-8'

## Download the web page
$results = Invoke-WebRequest $url | Foreach-Object Content

## Extract the text of the time, which is contained in
## a segment that looks like "<font size="7" color="white"><b>...<br>"
$match = $results -match '<font [^>]*><b>(.*)<br>'
if($matches)
{
    $time = $matches[1]
}

## Output the time
$time