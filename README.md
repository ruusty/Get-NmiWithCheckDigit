# Get-NmiCheckDigit #

~~~
Project:        GIS/OMS
Product:        Get-NmiCheckDigit
Version:        4.3 
Date:           2018-08-06 
Description:    Calculates a NMI with Check Digit for NMIs of length 10 or 11. 

CHED Services
~~~

<a name="TOC"></a>
# Table of Contents

- [Description](#Description)
- [Examples](#Examples)

<a name="Description"></a>
## Description [&uarr;](#TOC) ##

Implemented based on [National Metering Identifier Procedure](https://www.aemo.com.au/Electricity/National-Electricity-Market-NEM/Retail-and-metering/-/media/EBA9363B984841079712B3AAD374A859.ashx).

<a name="Examples"></a>
## Examples [&uarr;](#TOC) ##

~~~
. .\Get-NmiCheckDigit.ps1; Get-NmiCheckDigit.ps1 -nmi "QAAAVZZZZZ"
~~~

~~~
. .\Get-Nmi11.ps1;Get-Nmi11 -nmi "QAAAVZZZZZ"
~~~

~~~
. .\Get-Nmi11.ps1;@("QAAAVZZZZZ3","QAAAVZZZZZ") | Get-Nmi11
~~~
