#!/bin/bash

testStart=`date`;
echo "testing start: $testStart.";
echo "----------";

#----------------------------
# Check where bp-utils are
#----------------------------
testDir=$HOME/bp-utils; # change this if bp-utils are installed somewhere else
if ! cd $testDir; then echo "Stop: check if $testDir exist" >&2; exit 1; fi;

#-----------------------------
# Test existence of BioPerl
#-----------------------------
echo -ne "Testing if BioPerl is installed: ...";
if perldoc -l Bio::Perl; then
    echo " ... Great, bioperl found!"
else 
    echo "Stop: please install bioperl modules before using this utility" >&2
    exit 1;
fi

#-----------------------------
# Test options, one by one
#-----------------------------
if ./bioaln -a test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -a: it works!"; else echo "bioaln -a: failed"; fi
if ./bioaln -b test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -b: it works!"; else echo "bioaln -b: failed"; fi
if ./bioaln -c test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -c: it works!"; else echo "bioaln -c: failed"; fi
if ./bioaln -d 'JD1,118a' test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -d: it works!"; else echo "bioaln -d: failed"; fi
if ./bioaln -g test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -g: it works!"; else echo "bioaln -g: failed"; fi
if ./bioaln -i 'fasta' test-files/test-bioaln-pep2dna.nuc > /dev/null 2> /dev/null; then echo "bioaln -i: it works!"; else echo "bioaln -i: failed"; fi
if ./bioaln -l test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -l: it works!"; else echo "bioaln -l: failed"; fi
if ./bioaln -m test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -m: it works!"; else echo "bioaln -m: failed"; fi
if ./bioaln -n test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -n: it works!"; else echo "bioaln -n: failed"; fi
if ./bioaln -o'fasta' test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -o: it works!"; else echo "bioaln -o: failed"; fi
if ./bioaln -p 'JD1,118a,N40' test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -p: it works!"; else echo "bioaln -p: failed"; fi
if ./bioaln -r 'B31' test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -r: it works!"; else echo "bioaln -r: failed"; fi
if ./bioaln -s '80,100' test-files/test-bioaln.aln > /dev/null 2> /dev/null; then echo "bioaln -s: it works!"; else echo "bioaln -s: failed"; fi
if ./bioaln -u test-files/test-bioaln.aln > /dev/null 2> /dev/null; then echo "bioaln -u: it works!"; else echo "bioaln -u: failed"; fi
if ./bioaln -v test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -v: it works!"; else echo "bioaln -v: failed"; fi  # to fix output
if ./bioaln -w '60' test-files/test-bioaln.aln > /dev/null 2> /dev/null; then echo "bioaln -w: it works!"; else echo "bioaln -w: failed"; fi  # to fix output
if ./bioaln -A test-files/test-bioaln-cat*.aln > /dev/null 2> /dev/null; then echo "bioaln -A: it works!"; else echo "bioaln -A: failed"; fi
if ./bioaln -B test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -B: it works!"; else echo "bioaln -B: failed"; fi
if rm test-files/test-bioaln.cds.slice-*.aln; then echo "block files removed"; else echo "block files not found"; fi
if ./bioaln -C '90' test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -C: it works!"; else echo "bioaln -C: failed"; fi
if ./bioaln -D test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -D: it works!"; else echo "bioaln -D: failed"; fi
if ./bioaln -E 'B31' test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -E: it works!"; else echo "bioaln -E: failed"; fi  # no synopsis (okay)
if ./bioaln -F test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -F: it works!"; else echo "bioaln -F: failed"; fi
if ./bioaln -I'B31,1' test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -I: it works!"; else echo "bioaln -I: failed"; fi
if ./bioaln -L test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -L: it works!"; else echo "bioaln -L: failed"; fi
if ./bioaln -M test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -M: it works!"; else echo "bioaln -M: failed"; fi
if ./bioaln -P'test-files/test-bioaln-pep2dna.nuc' test-files/test-bioaln-pep2dna.aln > /dev/null 2> /dev/null; then echo "bioaln -P: it works!"; else echo "bioaln -P: failed"; fi
if ./bioaln -R '3' test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -R: it works!"; else echo "bioaln -R: failed"; fi
if ./bioaln -S test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -S: it works!"; else echo "bioaln -S: failed"; fi
if ./bioaln -T test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -T: it works!"; else echo "bioaln -T: failed"; fi
if ./bioaln -U test-files/test-bioaln.cds > /dev/null 2> /dev/null; then echo "bioaln -U: it works!"; else echo "bioaln -U: failed"; fi


testEnd=`date`;
echo "-------------";
echo "testing ends: $testEnd.";
exit;