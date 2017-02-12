###########################################################################
##
## Invoke-ScriptThatRequiresMta
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
###########################################################################

<#

.SYNOPSIS

Demonstrates a technique to relaunch a script that requires MTA mode.
This is useful only for simple parameter definitions that can be
specified positionally.

#>

param(
    $Parameter1,
    $Parameter2
)

Set-StrictMode -Version 3

"Current threading mode: " + $host.Runspace.ApartmentState
"Parameter1 is: $parameter1"
"Parameter2 is: $parameter2"

if($host.Runspace.ApartmentState -eq "STA")
{
    "Relaunching"
    $file = $myInvocation.MyCommand.Path
    powershell -NoProfile -Mta -File $file $parameter1 $parameter2
    return
}

"After relaunch - current threading mode: " + $host.Runspace.ApartmentState