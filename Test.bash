#!/bin/bash

function test {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "error with $1" >&2
    else echo "passed: $1"
    fi
    return $status
}

echo -ne "option: -c, DNA\n"
test ./bioseq -c test-files/test-bioseq.nuc 
echo -ne "\n-c, protein\n"
test ./bioseq -c test-files/test-bioseq.pep

echo -ne "\n-d\n"
test ./bioseq -d 'order:2' test-files/test-bioseq.nuc

echo -ne "\n-f\n"
test ./bioseq -f 'X83553' -o 'genbank'

echo -ne "\n-g, protein\n"
test ./bioseq -g test-files/test-bioseq.nuc

echo -ne "\n-i, protein\n"
test ./bioseq -i 'genbank' -F test-files/test-bioseq.gb 

echo -ne "\n-l, DNA\n"
test ./bioseq -l test-files/test-bioseq.nuc
echo -ne "\n-l, protein\n"
test ./bioseq -l test-files/test-bioseq.pep

echo -ne "\n-n\n"
test ./bioseq -n test-files/test-bioseq.nuc

echo -ne "\n-o\n"
test ./bioseq -i 'genbank' -o'fasta' test-files/test-bioseq.gb 

echo -ne "\n-p\n"
test ./bioseq -p 'order:2' test-files/test-bioseq.nuc
test ./bioseq -p 'order:2,4' test-files/test-bioseq.nuc
test ./bioseq -p 'order:2-4' test-files/test-bioseq.nuc

echo -ne "\n-r\n"
test ./bioseq -r test-files/test-bioseq.nuc

echo -ne "\n-s\n"
test ./bioseq -s '10,20' test-files/test-bioseq.nuc

echo -ne "\n-t\n"
test ./bioseq -t1 test-files/test-bioseq.nuc

echo -ne "\n-x\n"
test ./bioseq -x 'EcoRI' test-files/test-bioseq-re.fas  # to fix output

echo -ne "\n-A\n"
test ./bioseq -A test-files/test-bioseq.nuc

echo -ne "\n-B\n"
test ./bioseq -B test-files/test-bioseq.nuc

echo -ne "\n-C\n"
test ./bioseq -C test-files/test-bioseq.nuc

echo -ne "\n-F\n"
test ./bioseq -i 'genbank' -F test-files/test-bioseq.gb

echo -ne "\n-G\n"
test ./bioseq -G test-files/test-bioseq.nuc  # no synopsis (okay)

echo -ne "\n-H\n"
test ./bioseq -H test-files/test-bioseq.pep

echo -ne "\n-L\n"
test ./bioseq -L test-files/test-bioseq.nuc

echo -ne "\n-R\n"
test ./bioseq -R3 test-files/test-bioseq.nuc

echo -ne "\n-X\n"
test ./bioseq -X test-files/test-bioseq.nuc   # removed from synopsis

exit;