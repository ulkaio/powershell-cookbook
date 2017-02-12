##############################################################################
##
## Register-TemporaryEvent
##
## From Windows PowerShell Cookbook (O'Reilly)
## by Lee Holmes (http://www.leeholmes.com/guide)
##
##############################################################################

<#

.SYNOPSIS

Registers an event action for an object, and automatically unregisters
itself afterward. In PowerShell version three, use the -MaxTriggerCount
parameter of the Register-*Event cmdlets.

.EXAMPLE

PS > $timer = New-Object Timers.Timer
PS > Register-TemporaryEvent $timer Disposed { [Console]::Beep(100,100) }
PS > $timer.Dispose()
PS > Get-EventSubscriber
PS > Get-Job

#>

param(
    ## The object that generates the event
    $Object,

    ## The event to subscribe to
    $Event,

    ## The action to invoke when the event arrives
    [ScriptBlock] $Action
)

Set-StrictMode -Version 2

$actionText = $action.ToString()
$actionText += @'

$eventSubscriber | Unregister-Event
$eventSubscriber.Action | Remove-Job
'@

$eventAction = [ScriptBlock]::Create($actionText)
$null = Register-ObjectEvent $object $event -Action $eventAction