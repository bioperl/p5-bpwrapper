#!/bin/bash

min_bp_version=1.006
source ./test-setup.sh

#-----------------------------
# Test options, one by one
#-----------------------------
echo -ne "Testing bioseq -c: getting base composition ... "; if $BIOSEQ -c test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "it works!"; else echo "failed"; fi
if $BIOSEQ -i 'genbank' -o'fasta' test-files/test-bioseq.gb > /dev/null 2> /dev/null; then echo "bioseq -i (Genbank => Fasta): it works!"; else echo "bioseq -i: failed"; fi
if $BIOSEQ -x 'EcoRI' test-files/test-bioseq-re.fas > /dev/null 2> /dev/null; then echo "bioseq -x (restriction cut): it works!"; else echo "bioseq -x: failed"; fi  # to fix output
if $BIOSEQ -i 'genbank' -F test-files/test-bioseq.gb > /dev/null 2> /dev/null; then echo "bioseq -F (extract genes from a genbank file): it works!"; else echo "bioseq -F: failed"; fi
if $BIOSEQ -H test-files/test-bioseq.pep > /dev/null 2> /dev/null; then echo "bioseq -H (calculate hydrophobicity score): it works!"; else echo "bioseq -H: failed"; fi


testEnd=`date`;
echo "-------------";
echo "testing ends: $testEnd.";
exit;
