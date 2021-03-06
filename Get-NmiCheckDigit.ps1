function Get-NmiCheckDigit
{
  [CmdletBinding()]
  param
  (
    [Parameter(Mandatory = $true,
               Position = 0)]
    [ValidateScript({ ($_.Length -in @(10, 11)) })]
    [string]$Nmi
  )
  
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
  $rv = [Ruusty.Nmi_Luhn10]::NmiCheckSum($Nmi)
  Write-Host $rv
}
