#!/bin/bash

testStart=`date`;
echo "testing start: $testStart.";
echo "----------";

#----------------------------
# Check where bp-utils are
#----------------------------
testDir=$HOME/bp-utils; # change this if bp-utils are installed somewhere else
if ! cd $testDir; then echo "Stop: check if $testDir exist" >&2; exit 1; fi;

#-------------------------------------
# Test existence of BioPerl & version
#------------------------------------
echo -ne "Testing if BioPerl is installed: ...";
if perldoc -l Bio::Perl; then
    echo " ... Great, bioperl found!"
else 
    echo "Stop: please install bioperl modules before using this utility" >&2
    exit 1;
fi

bp_version=$(perl -MBio::Root::Version -e 'print $Bio::Root::Version::VERSION');
if_true=$(echo "$bp_version > 1.006" | bc);
if [ $if_true -ne 1 ]; then
    echo "Warning: Your BioPerl version ($bp_version) may be old (< 1.6) and some functions may fail."
else 
    echo "Great, your BioPerl version ($bp_version) is compatible."
fi;
#-----------------------------
# Test options, one by one
#-----------------------------
echo -ne "Testing bioseq -c: getting base composition ... "; if ./bioseq -c test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "it works!"; else echo "failed"; fi
if ./bioseq -c test-files/test-bioseq.pep > /dev/null 2> /dev/null; then echo "bioseq -c (aa composition): it works!"; else echo "bioseq -c: failed"; fi
if ./bioseq -d 'order:2' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -d (delete by order): it works!"; else echo "bioseq -d: failed"; fi
if ./bioseq -f 'X83553' -o 'genbank' > /dev/null 2> /dev/null; then echo "bioseq -f (fetch Genbank file): it works!"; else echo "bioseq -f: failed"; fi
if ./bioseq -g test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -g (remove gaps): it works!"; else echo "bioseq -g: failed"; fi
if ./bioseq -l test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -l (DNA seq length): it works!"; else echo "bioseq -l: failed"; fi
if ./bioseq -l test-files/test-bioseq.pep > /dev/null 2> /dev/null; then echo "bioseq -l (protein seq length): it works!"; else echo "bioseq -l: failed"; fi
if ./bioseq -n test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -n (number of sequences): it works!"; else echo "bioseq -n: failed"; fi
if ./bioseq -i 'genbank' -o'fasta' test-files/test-bioseq.gb > /dev/null 2> /dev/null; then echo "bioseq -i (Genbank => Fasta): it works!"; else echo "bioseq -i: failed"; fi
if ./bioseq -p 'order:2' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -p (pick 1 seq by order): it works!"; else echo "bioseq -p: failed"; fi
if ./bioseq -p 'order:2,4' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -p (pick seqs by order delimited by commas): it works!"; else echo "bioseq -p: failed"; fi
if ./bioseq -p 'order:2-4' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -p (pick seqs by order with range operator): it works!"; else echo "bioseq -p: failed"; fi
if ./bioseq -r test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -r (reverse complement seqs): it works!"; else echo "bioseq -r: failed"; fi
if ./bioseq -s '10,20' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -s (get sub-sequences): it works!"; else echo "bioseq -s: failed"; fi
if ./bioseq -t1 test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -t (translate dna): it works!"; else echo "bioseq -t: failed"; fi
if ./bioseq -x 'EcoRI' test-files/test-bioseq-re.fas > /dev/null 2> /dev/null; then echo "bioseq -x (restriction cut): it works!"; else echo "bioseq -x: failed"; fi  # to fix output
if ./bioseq -A test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -A (anonymize seq ids): it works!"; else echo "bioseq -A: failed"; fi
if rm *.sed; then echo "outputs cleaned"; else echo "bioseq -A failed. No files to clean"; fi
if ./bioseq -B test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -B (break into single-seq files): it works!"; else echo "bioseq -B: failed"; fi
if rm *11.fas; then echo "outputs cleaned"; else echo "bioseq -B failed. No files to clean"; fi
if ./bioseq -C test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -C (counts codons): it works!"; else echo "bioseq -C: failed"; fi
if ./bioseq -i 'genbank' -F test-files/test-bioseq.gb > /dev/null 2> /dev/null; then echo "bioseq -F (extract genes from a genbank file): it works!"; else echo "bioseq -F: failed"; fi
if ./bioseq -G test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -G (count leading gaps): it works!"; else echo "bioseq -G: failed"; fi  # no synopsis (okay)
if ./bioseq -H test-files/test-bioseq.pep > /dev/null 2> /dev/null; then echo "bioseq -H (calculate hydrophobicity score): it works!"; else echo "bioseq -H: failed"; fi
if ./bioseq -L test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -L (linearize FASTA seqs): it works!"; else echo "bioseq -L: failed"; fi
if ./bioseq -R3 test-files/test-bioseq-single-seq.nuc > /dev/null 2> /dev/null; then echo "bioseq -R (reloop a seq): it works!"; else echo "bioseq -R: failed"; fi
if ./bioseq -X test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -X (remove stop codons): it works!"; else echo "bioseq -X: failed"; fi   # removed from synopsis

testEnd=`date`;
echo "-------------";
echo "testing ends: $testEnd.";
exit;