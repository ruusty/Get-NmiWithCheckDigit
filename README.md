# Get-NmiCheckDigit #

~~~
Project:        GIS/OMS
Product:        Get-NmiCheckDigit
Version:        4.3 
Date:           2018-08-06 
Description:    Calculates a NMI Check Digit for NMIs of length 10 or 11. 

CHED Services
~~~

<a name="TOC"></a>
# Table of Contents

- [Description](#Description)

<a name="Description"></a>
## Description [&uarr;](#TOC) ##

Initial release. Powershell wrappers and Pester tests to come.

~~~
. .\Get-NmiCheckDigit.ps1; Get-NmiCheckDigit.ps1 -nmi "QAAAVZZZZZ"
~~~

~~~
. .\Get-Nmi11.ps1;Get-Nmi11 -nmi "QAAAVZZZZZ"
~~~

