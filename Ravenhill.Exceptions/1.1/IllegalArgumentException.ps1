class IllegalArgumentException : Exception {
  <#
  .SYNOPSIS
    Exception thrown when an argument is invalid.
  #>
  IllegalArgumentException([string] $message) : base($message) { }
}