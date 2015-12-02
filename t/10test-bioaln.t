#!/usr/bin/env perl
use rlib '.';
use strict; use warnings;
use Test::More;
use Helper;
note( "Testing bioaln single-letter options on bioaln.cds" );
# option b (background needs special care)
for my $letter (qw(a c g l m n u v A B D F L T)) {
    run_bio_program('bioaln', 'test-bioaln.cds', "-${letter}", "opt-${letter}.right");
}

note( "Testing bioaln option-value options on bioaln.cds" );
for my $tup (['d', 'JD1,118a'],
	     ['o', 'fasta'],
	     ['p', 'JD1,118a,N40'],
	     ['w', '60'],
	     ['r', 'B31'],
	     ['C', '90'],
	     ['E', 'B31'],
	     ['I', 'B31,1'])
{
    run_bio_program('bioaln', 'test-bioaln.cds', "-$tup->[0] $tup->[1]",
		    "opt-$tup->[0].right");
}

# Need to convert:
# M S U
# ['R', '3'])
# ['i', 'fasta'],
# ['s', '80,100'],
# -P'test-files/test-bioaln-pep2dna.nuc'
done_testing();
