
using System;
using System.Text;
using System.Linq;
/*Calculates a LUHN-10.
* 1. Double the value of alternate digits beginning with the rightmost digit
* 2. Add the individual digits comprising the products obtained in step 1 to each of the unaffected digits in the original number.
* 3. Find the next highest multiple of 10
* 4. The check digit is the value obtained in step 2 subtracted from the value obtained in step 3.
* 5. END
*/
namespace Ruusty
{
    /* Reference:0610-0008 pdf.pdf
        National Metering Identifier Procedure
        PREPARED BY: Market Development
        DOCUMENT NO: ME_GN059GN059
        VERSION NO: V5.1
        PREPARED FOR: National Electricity Market
        EFFECTIVE DATE: August 2009

     */
    public static class Nmi_Luhn10
    {
        public static string NmiCheckSum(string Nmi)
        {
            Nmi = IsNmi(Nmi);
            string ReverseNmi = new string(Nmi.ToCharArray().Reverse().ToArray());
            byte[] byteToCalculate = Encoding.ASCII.GetBytes(ReverseNmi);

            int checksum = 0;
            bool multiply = true;
            foreach (byte chData in byteToCalculate)
            {
                int d = chData;
                if (multiply)
                {
                    d *= 2;
                }
                multiply = !multiply;
                while (d > 0)
                {
                    checksum += d % 10;
                    d /= 10;
                }
              }
            checksum  = (10 - (checksum % 10)) % 10;
            return checksum.ToString();
        }
        private static string IsNmi(string Nmi)
        {
            if (!(Nmi.Length == 10 || Nmi.Length == 11))
            {
                throw new ArgumentException("Not a NMI (Length not in 10,11");
            }
            Nmi = Nmi.ToUpper().Substring(0, 10);
            byte[] byteToCalculate = Encoding.ASCII.GetBytes(Nmi);
            foreach (byte i in byteToCalculate)
            {
                //41 - 90 [A-Z]
                //30 - 39 [0-9]
                if (!((i >= 30 && i <= 39) || (i >= 41 && i <= 90)))
                {
                    throw new ArgumentException("Not a NMI character");
                }

            }
            return Nmi;
        }
        public static string NmiWithChecksum(string Nmi)
        {
            return IsNmi(Nmi) + NmiCheckSum(Nmi);
        }
    }
}

