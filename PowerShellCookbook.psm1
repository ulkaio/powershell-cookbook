$env:PATH = (($env:PATH -split ";") + $psScriptRoot) -join ";"

$MyInvocation.MyCommand.ScriptBlock.Module.OnRemove = {
    $env:PATH = $env:PATH.Replace(";$psScriptRoot", "")
}