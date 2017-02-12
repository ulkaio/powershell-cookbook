##############################################################################
##
## Watch-Command
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

<#

.SYNOPSIS

Watches the result of a command invocation, alerting you when the output
either matches a specified string, lacks a specified string, or has simply
changed.

.EXAMPLE

PS > Watch-Command { Get-Process -Name Notepad | Measure } -UntilChanged
Monitors Notepad processes until you start or stop one.

.EXAMPLE

PS > Watch-Command { Get-Process -Name Notepad | Measure } -Until "Count    : 1"
Monitors Notepad processes until there is exactly one open.

.EXAMPLE

PS > Watch-Command { Get-Process -Name Notepad | Measure } -While 'Count    : \d\s*\n'
Monitors Notepad processes while there are between 0 and 9 open
(once number after the colon).

#>


[CmdletBinding(DefaultParameterSetName = "Forever")]
param(
    ## The scriptblock to invoke while monitoring
    [Parameter(Mandatory = $true, Position = 0)]
    [ScriptBlock] $ScriptBlock,

    ## The delay, in seconds, between monitoring attempts
    [Parameter()]
    [Double] $DelaySeconds = 1,

    ## Specifies that the alert sound should not be played
    [Parameter()]
    [Switch] $Quiet,

    ## Monitoring continues only until while the output of the
    ## command remains the same.
    [Parameter(ParameterSetName = "UntilChanged", Mandatory = $false)]
    [Switch] $UntilChanged,

    ## The regular expression to search for. Monitoring continues
    ## until this expression is found.
    [Parameter(ParameterSetName = "Until", Mandatory = $false)]
    [String] $Until,

    ## The regular expression to search for. Monitoring continues
    ## until this expression is not found.
    [Parameter(ParameterSetName = "While", Mandatory = $false)]
    [String] $While
)

Set-StrictMode -Version 3

$initialOutput = ""

## Start a continuous loop
while($true)
{
    ## Run the provided script block
    $r = & $ScriptBlock

    ## Clear the screen and display the results
    Clear-Host
    $ScriptBlock.ToString().Trim()
    ""
    $textOutput = $r | Out-String
    $textOutput

    ## Remember the initial output, if we haven't
    ## stored it yet
    if(-not $initialOutput)
    {
        $initialOutput = $textOutput
    }

    ## If we are just looking for any change,
    ## see if the text has changed.
    if($UntilChanged)
    {
        if($initialOutput -ne $textOutput)
        {
            break
        }
    }

    ## If we need to ensure some text is found,
    ## break if we didn't find it.
    if($While)
    {
        if($textOutput -notmatch $While)
        {
            break
        }
    }

    ## If we need to wait for some text to be found,
    ## break if we find it.
    if($Until)
    {
        if($textOutput -match $Until)
        {
            break
        }
    }

    ## Delay
    Start-Sleep -Seconds $DelaySeconds
}

## Notify the user
if(-not $Quiet)
{
    [Console]::Beep(1000, 1000)
}