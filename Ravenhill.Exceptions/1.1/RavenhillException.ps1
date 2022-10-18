class RavenhillException : System.Exception {
  <#
  .SYNOPSIS
    Generic exception for the Ravenhill module.
  #>
  RavenhillException([string] $message) : base("The $message") { }
}