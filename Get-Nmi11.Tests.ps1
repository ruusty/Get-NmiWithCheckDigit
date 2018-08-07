[CmdletBinding()]
param
(
)
#region initialisation
$IsVerbose = $false
if ($PSCmdlet.MyInvocation.BoundParameters["Verbose"].IsPresent)
{
  $VerbosePreference = 'Continue'
  $IsVerbose = $true
}
Write-Host $('{0}==>{1}' -f '$Verbose', $Verbose)
Write-Host $('{0}==>{1}' -f '$VerbosePreference', $VerbosePreference)
$PSBoundParameters | Out-String | Write-Verbose

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sutName = [System.IO.Path]::GetFileNameWithoutExtension($MyInvocation.MyCommand.Path)
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
$cmdName = [System.IO.Path]::GetFileNameWithoutExtension($sut)

Write-Verbose $('$here:{0}' -f $here)
Write-Verbose $('$sut:{0}' -f $sut)

. $(Join-Path $PSScriptRoot $sut)

#endregion
#region setup dependencies
$DataDir = Join-Path $([System.IO.Path]::GetTempPath()) $("{0}.{1}" -f "$sutName", $([System.IO.Path]::GetRandomFileName()))
#Test Cases from 0610-0008 pdf.pdf (AEMO National Metering Identifier Procedure))
$TestCases =
@{nmi='2001985732';checknum=8},
@{nmi='QAAAVZZZZZ';checknum=3},
@{nmi='2001985733';checknum=6},
@{nmi='QCDWW00010';checknum=2},
@{nmi='3075621875';checknum=8},
@{nmi='SMVEW00085';checknum=8},
@{nmi='3075621876';checknum=6},
@{nmi='VAAA000065';checknum=7},
@{nmi='4316854005';checknum=9},
@{nmi='VAAA000066';checknum=5},
@{nmi='4316854006';checknum=7},
@{nmi='VAAA000067';checknum=2},
@{nmi='6305888444';checknum=6},
@{nmi='VAAASTY576';checknum=8},
@{nmi='6350888444';checknum=2},
@{nmi='VCCCX00009';checknum=1},
@{nmi='7001888333';checknum=8},
@{nmi='VEEEX00009';checknum=1},
@{nmi='7102000001';checknum=7},
@{nmi='VKTS786150';checknum=2},
@{nmi='NAAAMYS582';checknum=6},
@{nmi='VKTS867150';checknum=5},
@{nmi='NBBBX11110';checknum=0},
@{nmi='VKTS871650';checknum=7},
@{nmi='NBBBX11111';checknum=8},
@{nmi='VKTS876105';checknum=7},
@{nmi='NCCC519495';checknum=5},
@{nmi='VKTS876150';checknum=3},
@{nmi='NGGG000055';checknum=4},
@{nmi='VKTS876510';checknum=8}

$pipelineParam = @("20019857328", "QAAAVZZZZZ3", "20019857336", "QCDWW000102")

$pipelineParamSomeBad       = @("20019857328", "QAAAVZZ3", "2001219857336", "QCDWW000102")
$pipelineParamSomeBadReturn = @('20019857328',                              'QCDWW000102')


$dependencies = @(
  @{
    Label   = "All good"
    Test    = {$true }
    Action  = { }
  }
)

foreach ($dep in $dependencies)
{
  Write-Host $("Checking {0}" -f $dep.Label)
  & $dep.Action
  if (-not (& $dep.Test))
  {
    throw "The check: $($dep.Label) failed. Halting all tests."
  }
}
#endregion setup dependencies

# Invoke-pester  -Script @{ Path = './Get-Nmi11.Tests.ps1'; Parameters = @{ Verbose = $true;  } }

Describe "Get-Nmi11" {
  
  It "Should throw on invalid nmi" {
    {
      $rv = Get-Nmi11 -nmi "20019857"
    } | Should throw
  }
  
  It "Should do single nmi" {
    {
      $rv = Get-Nmi11 -nmi "2001985732"
      $rv |      Should be "20019857328"
    } | Should not throw
  }
  
  It "Should calculate Nmi of Length 11" -TestCases $testCases -Test {
    param (
      $nmi,
      $checknum
    )
    $rv = Get-Nmi11 -nmi $nmi
    $nmi11='{0}{1}' -f $nmi, $checknum
    $rv | Should be $nmi11
  }
  
    
  It "Should get all nmis from pipeline"{
    $rv = $pipelineParam | Get-Nmi11
    $rv | Should be $pipelineParam
  }
  
  
  It "Should get only good nmis from pipeline"{
    {
      $rv = $pipelineParamSomeBad | Get-Nmi11 -erroraction continue
      $rv | Should be $pipelineParamSomeBadReturn
    } | Should not throw
  }
  
  
  It "Should throw when bad nmis from pipeline"{
   { $rv = $pipelineParamSomeBad | Get-Nmi11 -erroraction stop } | Should throw
  }
}

