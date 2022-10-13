# Technique for await-ing WinRT APIs: https://fleexlab.blogspot.com/2018/02/using-winrts-iasyncoperation-in.html
Add-Type -AssemblyName System.Runtime.WindowsRuntime

# Reference WinRT assemblies
[Windows.Storage.StorageFile, Windows.Storage, ContentType = WindowsRuntime] | Out-Null
[Windows.Graphics.Imaging.BitmapDecoder, Windows.Graphics, ContentType = WindowsRuntime] | Out-Null

$RUNTIME_METHODS = [System.WindowsRuntimeSystemExtensions].GetMethods()
$AS_TASK_GENERIC = (
  $RUNTIME_METHODS | Where-Object {
    $_.Name -eq 'AsTask' `
      -and $_.GetParameters().Count -eq 1 `
      -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' 
  }
)[0]
$AS_TASK = (
  $runtimeMethods | Where-Object { 
    $_.Name -eq 'AsTask' `
      -and $_.GetParameters().Count -eq 1 `
      -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncAction' 
  }
)[0]

function Wait-Task {
  [CmdletBinding()]
  param (
    # The task to wait on.
    [Parameter(Mandatory, ValueFromPipeline)]
    [System.Threading.Tasks.Task]
    $Task
  )
  while (-not [System.Threading.Tasks.Task]::WaitAll(@($Task), 200)) { }
  return $Task.GetAwaiter().GetResult()
  <#
  .SYNOPSIS
    Waits for a task to complete.
  .DESCRIPTION
    Uses the `System.Threading` module to wait for a task to complete.
  .EXAMPLE
    PS> $task = Start-Task -Action {
    PS>   Write-Verbose "Task is running..."
    PS>   Start-Sleep -Seconds 5
    PS> }
    PS> Wait-Task $task
    PS> Write-Verbose "Task is complete."
  #>
}

function Wait-Action {
  param (
    # The task to wait on.
    [Parameter(Mandatory, ValueFromPipeline)]
    [System.Threading.Tasks.Task]
    $Task
  )
  $netTask = $asTask.Invoke($null, @($Task))
  $netTask.Wait() | Out-Null
}
