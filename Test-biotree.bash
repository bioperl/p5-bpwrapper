#!/bin/bash

source ./test-setup.sh

#--------------------------
# Test begins
#--------------------------
echo "testing biotree ...";

echo -ne "-d "; if $BIOTREE -d 'SV1,N40' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-l "; if $BIOTREE -l test-files/test-biotree.dnd  > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-n "; if $BIOTREE -n test-files/test-biotree.dnd  > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-o "; if $BIOTREE -o 'tabtree' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-r "; if $BIOTREE -r 'JD1' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-s "; if $BIOTREE -s 'SV1,B31,N40' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-u "; if $BIOTREE -u test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-A "; if $BIOTREE -A 'SV1,B31,N40' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-B "; if $BIOALN -B test-files/test-bioaln.aln > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-D "; if $BIOTREE -D test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-G "; if $BIOTREE -G 10 test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-L "; if $BIOTREE -L test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-M "; if $BIOTREE -M test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-P "; if $BIOTREE -P 'N40,B31,SV1' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-R "; if $BIOTREE -R test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-U "; if $BIOTREE -U 15 test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-W "; if $BIOTREE -W '156a' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi


# cat  tt.bash | sed 's/(^.+ )(-. )(.+$)/echo -ne "\2"; if \1\2\3 \> \/dev\/null 2\> \/dev\/null; then echo "works"; else echo "failed"; fi/'

testEnd=`date`;
echo "-------------";
echo "testing ends: $testEnd.";
exit;
