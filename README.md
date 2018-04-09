# DNAtranslator
convert a DNA sequence in to a protein sequence<br/>

Syntax: 	DNAtranslator(X)
     
    Inputs:
          X - It may be a raw DNA sequence or a text file (*.txt)
          where the sequence is stored. The sequence is a composed by
          A,T,G and C (upper or lower case) and the number of letteres
          must be a multiple of 3.
    Outputs:
          - amino acids translation

     Example: 

          Calling on Matlab the function: DNAtranslator('ATGCCC')

          Answer is:

          MP
          
          Calling on Matleb the function: DNAtranslator('cdna.txt')
          you will see the sequence of the SBDS protein

          Created by Giuseppe Cardillo
          giuseppe.cardillo-edta@poste.it

To cite this file, this would be an appropriate format:
Cardillo G. (2008) DNAtranslator: convert a DNA sequence into an amino
acids sequence. 
http://www.mathworks.com/matlabcentral/fileexchange/19973
