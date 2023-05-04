class NotInstalledException : Exception {
  <#
  .SYNOPSIS
    Exception thrown when a command is not installed.
  #>
  NotInstalledException([string] $message) : base("The $message") { }
}