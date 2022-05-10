# Ravenhill.Console

This module contains utility functions to manage powershell consoles.

## Set-RemoteSSH

Sets up an SSH key to a remote host like: ``user@hostname``.

This function will create a keypair and upload it to the specified host for the user defined
in the url.

### Syntax

```powershell
Set-RemoteSSH [-Url] <String> [-Algorithm <String>] [-Size <Int32>] [<CommonParameters>]

Set-RemoteSSH [-Url] <String> [-RSA] [-Size <Int32>] [<CommonParameters>]

Set-RemoteSSH [-Url] <String> [-ECDSA] [-Size <Int32>] [<CommonParameters>]

Set-RemoteSSH [-Url] <String> [-ED25519] [-Size <Int32>] [<CommonParameters>]
```

### Parameters

- ``Url <String>`` - The url of the host to register the key.
  The url should be in the form of:``user@hostname``

  |                             |       |
  | --------------------------- | ----- |
  | Required?                   | true  |
  | Position?                   | 1     |
  | Default value               | false |
  | Accept pipeline input?      | false |
  | Accept wildcard characters? | false |

- ``Algorithm <String>`` - The algorithm used to generate the key.
  
  |                             |       |
  | --------------------------- | ----- |
  | Required?                   | false |
  | Position?                   | named |
  | Default value               | rsa   |
  | Accept pipeline input?      | false |
  | Accept wildcard characters? | false |

- ``RSA [<SwitchParameter>]`` -
    An old algorithm based on the difficulty of factoring large numbers.
    A key size of at least 2048 bits is recommended for RSA; 4096 bits is better.
    RSA is getting old and significant advances are being made in factoring.
    Choosing a different algorithm may be advisable.
    It is quite possible the RSA algorithm will become practically breakable in the foreseeable
    future.
    All SSH clients support this algorithm.

  |                             |       |
  | --------------------------- | ----- |
  | Required?                   | false |
  | Position?                   | named |
  | Default value               | False |
  | Accept pipeline input?      | false |
  | Accept wildcard characters? | false |

- ``ECDSA [<SwitchParameter>]`` -
    A new Digital Signature Algorithm standarized by the US government, using elliptic curves.
    This is probably a good algorithm for current applications.
    Only three key sizes are supported: 256, 384, and 521 (sic) bits.
    We would recommend always using it with 521 bits, since the keys are still small and probably
    more secure than the smaller keys (even though they should be safe as well).
    Most SSH clients now support this algorithm.

  |                             |       |
  | --------------------------- | ----- |
  | Required?                   | false |
  | Position?                   | named |
  | Default value               | False |
  | Accept pipeline input?      | false |
  | Accept wildcard characters? | false |

- ``ED25519 [<SwitchParameter>]`` -
    This is a new algorithm added in OpenSSH.
    Support for it in clients is not yet universal.
    Thus its use in general purpose applications may not yet be advisable.

  |                             |       |
  | --------------------------- | ----- |
  | Required?                   | false |
  | Position?                   | named |
  | Default value               | False |
  | Accept pipeline input?      | false |
  | Accept wildcard characters? | false |

- ``Size <Int32>`` -
    The block size for the key.
    Default values are 521 for ECDSA, 256 for ED25519, and 4096 otherwise.

  |                             |                    |
  | --------------------------- | ------------------ |
  | Required?                   | false              |
  | Position?                   | named              |
  | Default value               | 521 OR 256 OR 4096 |
  | Accept pipeline input?      | false              |
  | Accept wildcard characters? | false              |

### Examples

```powershell
PS> # Creates a keypair and uploads it to user@hostname with the default algorithm.
PS> Set-RemoteSSH user@hostname
```

```powershell
PS > # Creates a keypair and uploads it to user@hostname with the algorithm "ed25519".
PS> Set-RemoteSSH user@hostname -Algorithm ed25519
```

```powershell
PS> # Creates a keypair and uploads it to user@hostname with the algorithm "ed25519" and a block
PS> # size of 2048.
PS> Set-RemoteSSH user@hostname -Algorithm ed25519 -Size 2048
```

```powershell
PS> # Creates a keypair and uploads it to user@hostname with the algorithm "ecdsa" and a block
PS> # size of 521 (default).
PS> Set-RemoteSSH user@hostname -ECDSA
```

```powershell
PS> # Tries to create a keypair and upload it to user@hostname with the algorithm "ecdsa" and a
PS> # block size of 512.
PS> Set-RemoteSSH user@hostname -ECDSA -Size 512
Exception: ECDSA key sizes must be one of 256, 384, or 521
```