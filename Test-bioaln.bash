#!/bin/bash

min_bp_version=1.006
source ./test-setup.sh

#-----------------------------
# Test options, one by one
#-----------------------------
if ./bioaln -b test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -b: it works!"; else echo "bioaln -b: failed"; fi
if ./bioaln -i 'fasta' test-files/test-bioaln-pep2dna.nuc > /dev/null 2> /dev/null; then echo "bioaln -i: it works!"; else echo "bioaln -i: failed"; fi
if ./bioaln -s '80,100' test-files/test-bioaln.aln > /dev/null 2> /dev/null; then echo "bioaln -s: it works!"; else echo "bioaln -s: failed"; fi
if rm test-files/test-bioaln.cds.slice-*.aln; then echo "block files removed"; else echo "block files not found"; fi
if ./bioaln -M test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -M: it works!"; else echo "bioaln -M: failed"; fi
if ./bioaln -P'test-files/test-bioaln-pep2dna.nuc' test-files/test-bioaln-pep2dna.aln > /dev/null 2> /dev/null; then echo "bioaln -P: it works!"; else echo "bioaln -P: failed"; fi
if ./bioaln -R '3' test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -R: it works!"; else echo "bioaln -R: failed"; fi
if ./bioaln -S test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -S: it works!"; else echo "bioaln -S: failed"; fi
if ./bioaln -U test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -U: it works!"; else echo "bioaln -U: failed"; fi


testEnd=`date`;
echo "-------------";
echo "testing ends: $testEnd.";
exit;
