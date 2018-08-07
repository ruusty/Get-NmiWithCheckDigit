<#
  .SYNOPSIS
    Returns  a NMI with Check Digit
  
  .DESCRIPTION
    Returns  a NMI with Check Digit
  
  .PARAMETER Nmi
    A NMI
  
  .EXAMPLE
    PS C:\> Get-Nmi11 -Nmi "QAAAVZZZZZ"
  
  .EXAMPLE
    PS C:\> Get-Nmi11 -Nmi "QAAAVZZZZZ3"
  .EXAMPLE
    PS C:\> @("QAAAVZZZZZ3","QAAAVZZZZZ") | Get-Nmi11 
  
  .NOTES
    Additional information about the function.
#>
function Get-Nmi11
{
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true,
               ValueFromPipeline = $true)]
    [ValidateScript({ ($_.Length -in @(10, 11)) })]
    [string]$Nmi
  )
  Begin
  {
    #region setup
    # Get the command name
    $CommandName = $PSCmdlet.MyInvocation.InvocationName;
    # Get the list of parameters for the command
    "${CommandName}: Input", (((Get-Command -Name ($PSCmdlet.MyInvocation.InvocationName)).Parameters) |
      %{ Get-Variable -Name $_.Values.Name -ErrorAction SilentlyContinue; } |
      Format-Table -AutoSize @{ Label = "Name"; Expression = { $_.Name }; }, @{ Label = "Value"; Expression = { (Get-Variable -Name $_.Name -EA SilentlyContinue).Value }; }) |
    Out-String | write-verbose
    #endregion
    $CSharp = Get-Content -Path $(Join-Path $PSScriptRoot "CalculateChecksum.cs") | Out-String
    Add-Type -TypeDefinition $CSharp -Language CSharp -Debug:$false
  }
  PROCESS
  {
    $nmi11 = [Ruusty.Nmi_Luhn10]::NmiWithChecksum($Nmi)
    Write-verbose $nmi11
    $nmi11
  }
  End
  {
  }
}

