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
if ./bioseq -c test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -c: it works!"; else echo "bioseq -c: failed"; fi
if ./bioseq -c test-files/test-bioseq.pep > /dev/null 2> /dev/null; then echo "bioseq -c: it works!"; else echo "bioseq -c: failed"; fi
if ./bioseq -d 'order:2' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -d: it works!"; else echo "bioseq -d: failed"; fi
if ./bioseq -f 'X83553' -o 'genbank' > /dev/null 2> /dev/null; then echo "bioseq -f: it works!"; else echo "bioseq -f: failed"; fi
if ./bioseq -g test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -g: it works!"; else echo "bioseq -g: failed"; fi
if ./bioseq -l test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -l: it works!"; else echo "bioseq -l: failed"; fi
if ./bioseq -l test-files/test-bioseq.pep > /dev/null 2> /dev/null; then echo "bioseq -l: it works!"; else echo "bioseq -l: failed"; fi
if ./bioseq -n test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -n: it works!"; else echo "bioseq -n: failed"; fi
if ./bioseq -i 'genbank' -o'fasta' test-files/test-bioseq.gb > /dev/null 2> /dev/null; then echo "bioseq -i: it works!"; else echo "bioseq -i: failed"; fi
if ./bioseq -p 'order:2' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -p: it works!"; else echo "bioseq -p: failed"; fi
if ./bioseq -p 'order:2,4' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -p: it works!"; else echo "bioseq -p: failed"; fi
if ./bioseq -p 'order:2-4' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -p: it works!"; else echo "bioseq -p: failed"; fi
if ./bioseq -r test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -r: it works!"; else echo "bioseq -r: failed"; fi
if ./bioseq -s '10,20' test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -s: it works!"; else echo "bioseq -s: failed"; fi
if ./bioseq -t1 test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -t: it works!"; else echo "bioseq -t: failed"; fi
if ./bioseq -x 'EcoRI' test-files/test-bioseq-re.fas > /dev/null 2> /dev/null; then echo "bioseq -x: it works!"; else echo "bioseq -x: failed"; fi  # to fix output
if ./bioseq -A test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -A: it works!"; else echo "bioseq -A: failed"; fi
if ./bioseq -B test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -B: it works!"; else echo "bioseq -B: failed"; fi
if ./bioseq -C test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -C: it works!"; else echo "bioseq -C: failed"; fi
if ./bioseq -i 'genbank' -F test-files/test-bioseq.gb > /dev/null 2> /dev/null; then echo "bioseq -F: it works!"; else echo "bioseq -F: failed"; fi
if ./bioseq -G test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -G: it works!"; else echo "bioseq -G: failed"; fi  # no synopsis (okay)
if ./bioseq -H test-files/test-bioseq.pep > /dev/null 2> /dev/null; then echo "bioseq -H: it works!"; else echo "bioseq -H: failed"; fi
if ./bioseq -L test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -L: it works!"; else echo "bioseq -L: failed"; fi
if ./bioseq -R3 test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -R: it works!"; else echo "bioseq -R: failed"; fi
if ./bioseq -X test-files/test-bioseq.nuc > /dev/null 2> /dev/null; then echo "bioseq -X: it works!"; else echo "bioseq -X: failed"; fi   # removed from synopsis

testEnd=`date`;
echo "-------------";
echo "testing ends: $testEnd.";
exit;