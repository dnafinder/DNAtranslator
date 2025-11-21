function ps = DNAtranslator(x)
%DNATRANSLATOR Convert a DNA sequence into a protein sequence.
%
%   Syntax
%   ------
%   DNAtranslator(X)
%   P = DNAtranslator(X)
%
%   Description
%   -----------
%   DNATRANSLATOR converts a DNA coding sequence into the corresponding
%   amino acid (protein) sequence using the standard genetic code.
%
%   The input X can be either:
%     - a raw DNA sequence (character vector or string scalar), or
%     - the name of a text file (*.txt) containing the DNA sequence.
%
%   The sequence is expected to:
%     - use only the bases A, T, G, C (upper or lower case);
%     - have a length that is an exact multiple of 3 after whitespace
%       removal.
%
%   DNATRANSLATOR displays the translated protein sequence in blocks of
%   60 amino acids per line. If an output argument is requested, it also
%   returns the protein sequence as a character row vector.
%
%   Inputs
%   ------
%   X : DNA sequence or file name
%       - If X matches an existing file, DNATRANSLATOR reads the file
%         contents and uses all characters (after removing whitespace) as
%         the DNA sequence.
%       - Otherwise, X is treated directly as the DNA sequence.
%       - X must be a character vector or a scalar string.
%
%   Outputs
%   -------
%   P : (optional) 1-by-N character row vector containing the amino acid
%       sequence translated using the standard genetic code.
%       If no output is requested, the sequence is only displayed.
%
%   Requirements
%   ------------
%   DNATRANSLATOR requires a file named "DNAcode.mat" to be accessible on
%   the MATLAB path. This MAT-file must contain a variable:
%
%       code
%
%   where:
%       - code is an N-by-M array with M ≥ 4;
%       - code may be numeric (ASCII codes) or a character array;
%       - columns 1:3 store the DNA codon triplets (A/T/G/C) in ASCII;
%       - column 4 stores the corresponding amino acid (single-letter
%         code, also in ASCII).
%
%   Example
%   -------
%   % Translate a short coding sequence directly:
%   DNAtranslator('ATGCCC')
%   % Displays:
%   %   MP
%
%   % Translate a sequence stored in a text file:
%   P = DNAtranslator('cdna.txt');
%   % P contains the amino acid sequence read from the file.
%
%   Citation
%   --------
%   If you use this function in academic or technical work, please cite:
%
%     Cardillo G. (2008)
%     "DNAtranslator: convert a DNA sequence into an amino acids sequence".
%     Available from GitHub:
%     https://github.com/dnafinder/DNAtranslator
%
%   Metadata
%   --------
%   Author : Giuseppe Cardillo
%   Email  : giuseppe.cardillo.75@gmail.com
%   GitHub : https://github.com/dnafinder
%   Created: 2008-01-01
%   Updated: 2025-11-21
%   Version: 2.0.2
%
%   License
%   -------
%   This function is distributed under the MIT License.
%   See the LICENSE file in the GitHub repository for details.
%

% -------------------------------------------------------------------------
% Validate and interpret input
% -------------------------------------------------------------------------
if nargin ~= 1
    error('DNAtranslator:InvalidNumArgs', ...
        'DNAtranslator expects exactly one input argument (sequence or file name).');
end

% Accept char vector or scalar string
if isstring(x)
    if ~isscalar(x)
        error('DNAtranslator:InvalidInputType', ...
            'Input X must be a character vector or a scalar string.');
    end
    x = char(x);
elseif ~ischar(x)
    error('DNAtranslator:InvalidInputType', ...
        'Input X must be a character vector or a scalar string.');
end

x = strtrim(x);

% Decide whether X is a file name or a raw sequence.
if exist(x,'file') == 2
    % X is interpreted as a text file
    seqRaw = fileread(x);          % read entire file contents
else
    % X is interpreted as a raw DNA sequence
    seqRaw = x;
end

% -------------------------------------------------------------------------
% Clean and check the DNA sequence
% -------------------------------------------------------------------------
% Convert to upper case and remove all whitespace characters
seq = upper(regexprep(seqRaw, '\s', ''));

if isempty(seq)
    error('DNAtranslator:EmptySequence', ...
        'The DNA sequence is empty after removing whitespace.');
end

% Check that the length is a multiple of 3
if mod(numel(seq),3) ~= 0
    error('DNAtranslator:LengthNotMultipleOfThree', ...
        'Check the sequence: the length must be a multiple of 3.');
end

% Check that all characters are valid nucleotides A, T, G, C
validBases = ismember(seq, 'ATGC');
if ~all(validBases)
    error('DNAtranslator:InvalidCharacters', ...
        'Check the sequence: all letters must be A, T, G or C.');
end

% -------------------------------------------------------------------------
% Load standard DNA code and translate
% -------------------------------------------------------------------------
persistent codeMatrix

if isempty(codeMatrix)
    try
        S = load('DNAcode.mat','code');
    catch
        error('DNAtranslator:MissingCodeFile', ...
            'Unable to load DNAcode.mat. Ensure it is on the MATLAB path.');
    end

    if ~isfield(S,'code')
        error('DNAtranslator:InvalidCodeFile', ...
            'DNAcode.mat does not contain a variable named "code".');
    end

    codeRaw = S.code;

    % Basic structural validation:
    % - numeric or char array
    % - at least 4 columns (we will use only the first 4)
    if ~(isnumeric(codeRaw) || ischar(codeRaw)) || size(codeRaw,2) < 4
        error('DNAtranslator:InvalidCodeFormat', ...
            'The "code" variable must be numeric or char with at least 4 columns.');
    end

    % Convert to numeric ASCII matrix and keep only first 4 columns:
    % columns 1:3 -> codon, column 4 -> amino acid
    if ischar(codeRaw)
        codeMatrix = double(codeRaw(:,1:4));
    else
        codeMatrix = codeRaw(:,1:4);
    end
end

code = codeMatrix;   % numeric ASCII (N-by-4)

% Each row of cd is a codon (three nucleotides, ASCII codes)
seqAscii = double(seq);
cd = reshape(seqAscii, 3, []).';  %#ok<UDIM>

% Find codons in the code matrix (first 3 columns)
[isFound, codonIdx] = ismember(cd, code(:,1:3), 'rows');

if ~all(isFound)
    error('DNAtranslator:UnknownCodon', ...
        'One or more codons in the sequence are not present in DNAcode.mat.');
end

% Translate to amino acids (fourth column, ASCII)
protein = char(code(codonIdx,4)).';

% -------------------------------------------------------------------------
% Display the protein sequence in blocks of 60 characters
% -------------------------------------------------------------------------
L = numel(protein);
blockSize = 60;

if L <= blockSize
    disp(protein);
else
    for k = 1:blockSize:L
        lastIdx = min(k + blockSize - 1, L);
        disp(protein(k:lastIdx));
    end
end

% -------------------------------------------------------------------------
% Optional output
% -------------------------------------------------------------------------
if nargout > 0
    ps = protein;
end

end

