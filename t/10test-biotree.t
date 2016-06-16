#!/usr/bin/env perl
use rlib '.';
use strict; use warnings;
use Test::More;
use Config;
use Helper;
note( "Testing biotree single-letter options on test-biotree.dnd" );


my %notes = (
    l => 'total branch length',
    n => 'total number of OTUs',
    u => 'leaf nodes with branch lengths',
    B => 'prepends ID to leaf/node labels',
    D => 'half-matrix list of distances between leaves',
    L => 'nodes and branch lengths',
    M => 'build tree of random subset',
    R => 'remove branch lengths from tree',
);
# option b (background needs special care)
for my $letter (qw(l n u B D L R)) {
    run_bio_program('biotree', 'test-biotree.dnd', "-${letter}", "opt-${letter}.right");
}

%notes = (
    d => 'distance between a pair of nodes or leaves',
    o => 'Output file format tabtree',
    r => 'reroot tree',
    s => 'specified leaves/nodes and their descendants',
    A => 'Least Common Ancestor',
    G => 'divide tree into 10 segments and count branches',
    P => 'depth to root',
    U => "Prints OTU's descended from node 15",
    W => 'walk tree from 156a',
);

# Output is different when Perl is configured with longdouble defined
my %longdouble = ();
if ($Config{longdouble}) {
    $longdouble{'G'} = 1;
}

note( "Testing biotree option-value options on test-bioatree.dnd" );
for my $tup (['d', 'SV1,N40'],
	     ['o', 'tabtree'],
	     ['s', 'SV1,B31,N40'],
	     ['A', 'SV1,B31,N40'],
	     ['G', '10'],
	     ['P', 'N40,B31,SV1'],
	     ['U', '15'],
	     ['W', '156a'],
)
{
    my ($letter, $args) = @$tup;
    if ($longdouble{$letter}) {
	print("skipping option '${letter}' because this perl has longdouble\n");
	run_bio_program('biotree', 'test-biotree.dnd', "-$letter $args",
			"opt-$letter-longdouble.right", {note=>$notes{$tup->[0]}});
    } else {
	run_bio_program('biotree', 'test-biotree.dnd', "-$letter $args",
			"opt-$letter.right", {note=>$notes{$letter}});
    }
}

%notes = (
    M => "random",
);


for my $letter (keys %notes) {
    run_bio_program_nocheck('biotree', 'test-biotree.dnd', "-${letter}",
			    {note=>$notes{$letter}});
}

note( "Skipping biotree -r JD1 - needs investigation" );
# run_bio_program_nocheck('biotree', 'test-biotree.dnd', "-r JD1",
#			{note=>"resample"});

done_testing();
