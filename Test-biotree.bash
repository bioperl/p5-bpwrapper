#!/bin/bash

echo "testing biotree ...";

echo -ne "-d "; if ./biotree -d 'SV1,N40' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-l "; if ./biotree -l test-files/test-biotree.dnd  > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-n "; if ./biotree -n test-files/test-biotree.dnd  > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-o "; if ./biotree -o 'tabtree' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-r "; if ./biotree -r 'JD1' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-s "; if ./biotree -s 'SV1,B31,N40' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-u "; if ./biotree -u test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-A "; if ./biotree -A 'SV1,B31,N40' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-B "; if ./bioaln -B test-files/test-bioaln.aln > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-D "; if ./biotree -D test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-G "; if ./biotree -G 10 test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-L "; if ./biotree -L test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-M "; if ./biotree -M test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-P "; if ./biotree -P 'N40,B31,SV1' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-R "; if ./biotree -R test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-U "; if ./biotree -U 15 test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi
echo -ne "-W "; if ./biotree -W '156a' test-files/test-biotree.dnd > /dev/null 2> /dev/null; then echo "works"; else echo "failed"; fi


# cat  tt.bash | sed 's/(^.+ )(-. )(.+$)/echo -ne "\2"; if \1\2\3 \> \/dev\/null 2\> \/dev\/null; then echo "works"; else echo "failed"; fi/'
