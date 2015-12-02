#!/bin/bash

min_bp_version=1.006
source ./test-setup.sh

#-----------------------------
# Test options, one by one
#-----------------------------
echo -ne "Testing bioseq -c: getting base composition ... "; if ./bioseq -c test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "it works!"; else echo "failed"; fi
if $BIOSEQ -c test-files/test-bioseq.pep > /dev/null 2> /dev/null; then echo "bioseq -c (aa composition): it works!"; else echo "bioseq -c: failed"; fi
if $BIOSEQ -d 'order:2' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -d (delete by order): it works!"; else echo "bioseq -d: failed"; fi
if $BIOSEQ -f 'X83553' -o 'genbank' > /dev/null 2> /dev/null; then echo "bioseq -f (fetch Genbank file): it works!"; else echo "bioseq -f: failed"; fi
if $BIOSEQ -g test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -g (remove gaps): it works!"; else echo "bioseq -g: failed"; fi
if $BIOSEQ -l test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -l (DNA seq length): it works!"; else echo "bioseq -l: failed"; fi
if $BIOSEQ -l test-files/test-bioseq.pep > /dev/null 2> /dev/null; then echo "bioseq -l (protein seq length): it works!"; else echo "bioseq -l: failed"; fi
if $BIOSEQ -n test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -n (number of sequences): it works!"; else echo "bioseq -n: failed"; fi
if $BIOSEQ -i 'genbank' -o'fasta' test-files/test-bioseq.gb > /dev/null 2> /dev/null; then echo "bioseq -i (Genbank => Fasta): it works!"; else echo "bioseq -i: failed"; fi
if $BIOSEQ -p 'order:2' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -p (pick 1 seq by order): it works!"; else echo "bioseq -p: failed"; fi
if $BIOSEQ -p 'order:2,4' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -p (pick seqs by order delimited by commas): it works!"; else echo "bioseq -p: failed"; fi
if $BIOSEQ -p 'order:2-4' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -p (pick seqs by order with range operator): it works!"; else echo "bioseq -p: failed"; fi
if $BIOSEQ -r test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -r (reverse complement seqs): it works!"; else echo "bioseq -r: failed"; fi
if $BIOSEQ -s '10,20' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -s (get sub-sequences): it works!"; else echo "bioseq -s: failed"; fi
if $BIOSEQ -t1 test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -t (translate dna): it works!"; else echo "bioseq -t: failed"; fi
if $BIOSEQ -x 'EcoRI' test-files/test-bioseq-re.fas > /dev/null 2> /dev/null; then echo "bioseq -x (restriction cut): it works!"; else echo "bioseq -x: failed"; fi  # to fix output
if $BIOSEQ -A test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -A (anonymize seq ids): it works!"; else echo "bioseq -A: failed"; fi
if rm *.sed; then echo "outputs cleaned"; else echo "bioseq -A failed. No files to clean"; fi
if $BIOSEQ -B test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -B (break into single-seq files): it works!"; else echo "bioseq -B: failed"; fi
if rm *11.fas; then echo "outputs cleaned"; else echo "bioseq -B failed. No files to clean"; fi
if $BIOSEQ -C test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -C (counts codons): it works!"; else echo "bioseq -C: failed"; fi
if $BIOSEQ -i 'genbank' -F test-files/test-bioseq.gb > /dev/null 2> /dev/null; then echo "bioseq -F (extract genes from a genbank file): it works!"; else echo "bioseq -F: failed"; fi
if $BIOSEQ -G test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -G (count leading gaps): it works!"; else echo "bioseq -G: failed"; fi  # no synopsis (okay)
if $BIOSEQ -H test-files/test-bioseq.pep > /dev/null 2> /dev/null; then echo "bioseq -H (calculate hydrophobicity score): it works!"; else echo "bioseq -H: failed"; fi
if $BIOSEQ -L test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -L (linearize FASTA seqs): it works!"; else echo "bioseq -L: failed"; fi
if $BIOSEQ -R3 test-files/test-bioseq-single-seq.nuc > /dev/null 2> /dev/null; then echo "bioseq -R (reloop a seq): it works!"; else echo "bioseq -R: failed"; fi
if $BIOSEQ -X test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -X (remove stop codons): it works!"; else echo "bioseq -X: failed"; fi   # removed from synopsis

testEnd=`date`;
echo "-------------";
echo "testing ends: $testEnd.";
exit;
