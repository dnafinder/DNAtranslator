function ps=DNAtranslator(x)
%DNAtranslator: convert a DNA sequence in to a protein sequence.
%
% Syntax: 	DNAtranslator(X)
%      
%     Inputs:
%           X - It may be a raw DNA sequence or a text file (*.txt)
%           where the sequence is stored. The sequence is a composed by
%           A,T,G and C (upper or lower case) and the number of letteres
%           must be a multiple of 3.
%     Outputs:
%           - amino acids translation
%
%      Example: 
%
%           Calling on Matlab the function: DNAtranslator('ATGCCC')
%
%           Answer is:
%
%           MP
%           
%           Calling on Matleb the function: DNAtranslator('cdna.txt')
%           you will see the sequence of the SBDS protein
%
%           Created by Giuseppe Cardillo
%           giuseppe.cardillo-edta@poste.it
%
% To cite this file, this would be an appropriate format:
% Cardillo G. (2008) DNAtranslator: convert a DNA sequence into an amino
% acids sequence. 
% http://www.mathworks.com/matlabcentral/fileexchange/19973

if exist(x,'file') %x is a text file
    fid=fopen(x,'r'); %open the file
    text=upper(fgetl(fid)); %get the cDNA and convert in upper case
    fclose(fid); %close the file
else %x is not a text file
    text=upper(x); %convert in upper case
end
%check if there are the correct number of letters
assert(mod(length(text),3)==0,'Check the sequence: the length must be a multiple of 3')
assert(isequal(length(text),length(regexp(text, '[ATGC]'))),'Check the sequence: all letters must be A,T,G or C')

text=double(text); %convert in ASCII code
%create a Nx3 matrix: each row is a codon
cd=reshape(text,3,length(text)/3)';
%Load the Standard DNA code matrix
load DNAcode.mat code
%find the codon in the matrix...
[~,codon]=ismember(cd,code(:,1:3),'rows');
%...and translate it in an amino acid
protein=char(code(codon,4))';
%display the conversion
L=length(protein);
if L<=60
    disp(protein)
else
    i=1;
    while i<=L
        if i+59<L
            disp(protein(i:i+59))
        else
            disp(protein(i:end))
        end
        i=i+60;
    end
end

if nargout
    ps=protein;
end