[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=dnafinder/DNAtranslator)

📌 Overview
This repository provides the MATLAB function DNAtranslator, which converts a DNA coding sequence into the corresponding amino acid (protein) sequence using the standard genetic code. The input can be either a raw DNA string (composed of A, T, G, C) or the name of a text file containing the sequence. The function checks basic validity (multiples of three nucleotides, allowed bases only), performs the translation via a codon table stored in DNAcode.mat, and prints the resulting protein sequence in fixed-length lines.

✨ Features
DNAtranslator offers the following features:
- Accepts DNA sequences as either direct input (character vector or string scalar) or as the name of a text file.
- Converts lower- or upper-case DNA sequences to uppercase and removes whitespace before translation.
- Validates that the sequence length is a multiple of three nucleotides and that only the bases A, T, G, and C are present.
- Uses a configurable codon table stored in DNAcode.mat (variable “code”) that implements the standard genetic code: three columns for the codons and one column for the amino acid single-letter codes.
- Translates the DNA sequence into a protein sequence using the standard genetic code.
- Displays the protein as contiguous lines of up to 60 amino acids, making long sequences easier to inspect.
- Optionally returns the protein sequence as a character row vector if an output argument is requested.

⚙️ Installation
To install and use DNAtranslator:
1. Download or clone this repository from GitHub:
   https://github.com/dnafinder/dnatranslator
2. Ensure that DNAtranslator.m and DNAcode.mat are both on your MATLAB path. You can add the folder containing these files using the MATLAB path management GUI or with the addpath command.
3. Confirm that DNAcode.mat contains a variable named “code”, stored as an N-by-4 character array, where the first three columns are codon triplets (e.g. 'ATG') and the fourth column is the corresponding amino acid single-letter code (e.g. 'M').

▶️ Usage
The main entry point is the function DNAtranslator:

- DNAtranslator(X)
  Reads or interprets X as a DNA sequence, translates it to a protein sequence, and prints the amino acid sequence to the Command Window without returning any output.

- P = DNAtranslator(X)
  Performs the same translation, prints the amino acid sequence, and also returns it as a character row vector P.

If X matches the name of an existing file, DNAtranslator reads the file contents and uses all non-whitespace characters as the DNA sequence. Otherwise, X is treated directly as the DNA sequence.

Example usages:
- DNAtranslator('ATGCCC')
  Translates the short coding sequence ATGCCC and prints the protein sequence:
    MP

- P = DNAtranslator('cdna.txt')
  Reads the DNA sequence from cdna.txt, translates it to a protein, prints the sequence, and stores it in P.

📥 Inputs
The function accepts a single input:

X : DNA sequence or file name
    - If X is the name of an existing file, that file is read using fileread, and all whitespace (spaces, tabs, newlines) is removed. The remaining characters are used as the DNA sequence.
    - If X is not an existing file, it is interpreted directly as the DNA sequence.
    - X must be either a character vector or a scalar string.

After cleaning, the sequence must:
- be non-empty;
- have a length that is an exact multiple of three;
- consist only of the nucleotides A, T, G, and C.

📤 Outputs
DNAtranslator can optionally return the translated protein sequence:

- If you call DNAtranslator(X) without an output argument, the function translates the sequence and prints the amino acid sequence in blocks of 60 characters per line.
- If you call P = DNAtranslator(X), the function also returns the protein sequence as a 1-by-N character row vector P, where each character corresponds to a single amino acid in standard one-letter code.

The printed output is designed for readability, especially for long sequences, by wrapping every 60 residues onto a new line.

🔍 Interpretation
DNAtranslator is intended for quick, local conversions from nucleotide sequences to amino acid sequences without the need for web-based tools or external services. By relying on a local DNAcode.mat file, you have full control over the codon table and can:
- verify the standard genetic code used by the function;
- adapt or extend the codon table for alternative genetic codes if needed (e.g. mitochondrial codes) by editing DNAcode.mat.

The function assumes that the input sequence is already in the correct reading frame and that there are no introns or other non-coding interruptions. Stop codons, if defined in DNAcode.mat, will be translated according to the corresponding entry in the table (for example, as '*' or another chosen symbol).

Because the function performs strict checks on sequence length and allowed bases, it can also help catch simple input errors such as missing nucleotides, unexpected characters, or accidental whitespace.

📝 Notes
- DNAtranslator does not attempt to detect or shift reading frames; it assumes that the provided sequence is in-frame and coding.
- Only the characters A, T, G, and C are accepted as nucleotides. Any other character in the cleaned sequence will cause a descriptive error.
- The function reads entire text files using fileread, which allows for multi-line sequences and ignores whitespace such as spaces and newlines.
- The translation relies entirely on the contents of DNAcode.mat. If codons in the input sequence are not found in the codon table, the function throws an error indicating that unknown codons are present.
- The function uses only core MATLAB functionality and does not require additional toolboxes.

📚 Citation
If you use this function or its results in a publication, thesis, or technical report, please cite:

Cardillo G. (2008)
"DNAtranslator: convert a DNA sequence into an amino acids sequence".
Available from GitHub:
https://github.com/dnafinder/DNAtranslator

👤 Author
Author: Giuseppe Cardillo
Email: giuseppe.cardillo.75@gmail.com
GitHub: https://github.com/dnafinder

⚖️ License
This project is distributed under the MIT License. You are free to use, modify, and redistribute the code, provided that the original copyright notice and license text are preserved. The full license terms are provided in the LICENSE file in this GitHub repository.
