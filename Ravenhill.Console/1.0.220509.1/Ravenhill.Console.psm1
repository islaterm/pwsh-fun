function Set-RemoteSSH {
  [CmdletBinding(DefaultParameterSetName='AlgorithmRaw')]
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]
    $Url,
    [Parameter(ParameterSetName = 'AlgorithmRaw')]
    [Alias('a', 't')]
    [string]
    $Algorithm,
    [Parameter(ParameterSetName = 'AlgorithmRSA')]
    [switch]
    $RSA,
    [Parameter(ParameterSetName = 'AlgorithmECDSA')]
    [switch]
    $ECDSA,
    [Parameter(ParameterSetName = 'AlgorithmED25519')]
    [switch]
    $ED25519,
    [Alias('b', 's')]
    [int]
    $Size
  )
  $Algorithm = $RSA -or -not $PSBoundParameters.ContainsKey('Algorithm') ? 'rsa' : `
    $ECDSA ? 'ecdsa' : $ED25519 ? 'ed25519' : $Algorithm
  if ($Algorithm -eq 'ecdsa' -and $(-not $(256, 384, 521) -contains $Size)) {
    throw "ECDSA key sizes must be one of 256, 384, or 521"
  }
  if (-not $PSBoundParameters.ContainsKey('Size')) {
    $Size = $Algorithm -eq 'ecdsa' ? 521 : $Algorithm -eq 'ed25519' ? 256 : 4096
  }
  $keyPath = "$Env:USERPROFILE\.ssh\id_$Algorithm"
  ssh-keygen.exe -t $Algorithm -b $Size -f $keyPath
  ssh $Url mkdir -p .ssh -v
  Get-Content "$keyPath.pub" | ssh $Url "cat -v >> .ssh/authorized_keys"
  <#
    .SYNOPSIS
      Sets up an SSH key to a remote host like: user@hostname.
    .DESCRIPTION
      This function will create a keypair and upload it to the specified host for the user defined 
      in the url.
    .PARAMETER Url
      The url of the host to register the key.
      The url should be in the form of:
        user@hostname
    .PARAMETER Algorithm
      The algorithm used to generate the key.
      Defaults to "rsa".
    .PARAMETER RSA
      An old algorithm based on the difficulty of factoring large numbers. 
      A key size of at least 2048 bits is recommended for RSA; 4096 bits is better. 
      RSA is getting old and significant advances are being made in factoring. 
      Choosing a different algorithm may be advisable. 
      It is quite possible the RSA algorithm will become practically breakable in the foreseeable 
      future. 
      All SSH clients support this algorithm.
    .PARAMETER ECDSA
      A new Digital Signature Algorithm standarized by the US government, using elliptic curves. 
      This is probably a good algorithm for current applications. 
      Only three key sizes are supported: 256, 384, and 521 (sic) bits. 
      We would recommend always using it with 521 bits, since the keys are still small and probably 
      more secure than the smaller keys (even though they should be safe as well). 
      Most SSH clients now support this algorithm.
    .PARAMETER ED25519
      This is a new algorithm added in OpenSSH. 
      Support for it in clients is not yet universal. 
      Thus its use in general purpose applications may not yet be advisable.
    .PARAMETER Size
      The block size for the key.
      Default values are 521 for ECDSA, 256 for ED25519, and 4096 otherwise.
    .EXAMPLE
      # Creates a keypair and uploads it to user@hostname with the default algorithm.
      PS> Set-RemoteSSH user@hostname
    .EXAMPLE
      # Creates a keypair and uploads it to user@hostname with the algorithm "ed25519".
      PS> Set-RemoteSSH user@hostname -Algorithm ed25519
    .EXAMPLE
      # Creates a keypair and uploads it to user@hostname with the algorithm "ed25519" and a block 
      # size of 2048.
      PS> Set-RemoteSSH user@hostname -Algorithm ed25519 -Size 2048
    .EXAMPLE
      # Creates a keypair and uploads it to user@hostname with the algorithm "ecdsa" and a block
      # size of 521 (default).
      PS> Set-RemoteSSH user@hostname -ECDSA
    .EXAMPLE
      # Tries to create a keypair and upload it to user@hostname with the algorithm "ecdsa" and a
      # block size of 512.
      PS> Set-RemoteSSH user@hostname -ECDSA -Size 512
      Exception: ECDSA key sizes must be one of 256, 384, or 521
  #>
}

function Set-LocationSwapDrive {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$true, Position=0)]
    [string]
    $Drive
  )
  
}