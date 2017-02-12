##############################################################################
##
## Search-Bing
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

<#

.SYNOPSIS

Search Bing for a given term

.EXAMPLE

PS > Search-Bing PowerShell
Searches Bing for the term "PowerShell"

#>

param(
    ## The term to search for
    $Pattern = "PowerShell"
)

Set-StrictMode -Version 3

## Create the URL that contains the Twitter search results
Add-Type -Assembly System.Web
$queryUrl = 'http://www.bing.com/search?q={0}'
$queryUrl = $queryUrl -f ([System.Web.HttpUtility]::UrlEncode($pattern))

## Download the web page
$results = [string] (Invoke-WebRequest $queryUrl)

## Extract the text of the results, which are contained in
## segments that look like "<div class="sb_tlst">...</div>"
$matches = $results |
    Select-String -Pattern '(?s)<div[^>]*sb_tlst[^>]*>.*?</div>' -AllMatches

foreach($match in $matches.Matches)
{
    ## Extract the URL, keeping only the text inside the quotes
    ## of the HREF
    $url = $match.Value -replace '.*href="(.*?)".*','$1'
    $url = [System.Web.HttpUtility]::UrlDecode($url)

    ## Extract the page name,  replace anything in angle
    ## brackets with an empty string.
    $item = $match.Value -replace '<[^>]*>', ''

    ## Output the item
    [PSCustomObject] @{ Item = $item; Url = $url }
}