#!/usr/bin/env perl
use rlib '.';
use strict; use warnings;
use Test::More;
use Config;
use Helper;
note( "Testing bioaln single-letter options on test-bioaln.cds" );


my %notes = (
    a => 'average percent identity',
    c => 'codon view',
    g => 'remove gapped sites',
    l => 'length of an alignment',
    m => 'match view',
    n => 'number of aligned sequences',
    u => 'remove redundant sequences',
    v => 'show only variable sites',
    A => 'concatenate aln files',
    B => 'extract conserved blocks',
    D => 'DNA alignment',
    F => 'set display name flat',
    L => 'list all sequence IDs',
    T => 'extract third site',
);

# Output is different when Perl is configured with longdouble defined
my %longdouble = ();
if ($Config{longdouble}) {
    $longdouble{'a'} = 1;
}

# option a changes depending on whether Perl was set to
# to use longdouble or not
# option b (background needs special care)
for my $letter (keys %notes) {
    if ($longdouble{$letter}) {
	print("skipping option '${letter}' because this perl has longdouble\n");
	# run_bio_program('bioaln', 'test-bioaln.cds', "-${letter}", "opt-${letter}-longdouble.right");
    }  else {
	run_bio_program('bioaln', 'test-bioaln.cds', "-${letter}", "opt-${letter}.right",
			{note=>$notes{$letter}});
    }
}


note( "Testing bioaln option-value options on test-bioaln.cds" );

%notes = (
    d => 'delete sequences JD1, 118a',
    o => 'output a FASTA alignments',
    p => 'pick sequences JD1, 118a, N40',
    w => 'average identifies for sliding windows of 60',
    r => 'change reference (or first) sequence',
    C => 'add a 90% consensus sequence',
    E => 'Erase sites gapped at B31',
    I => "get align column index of seq 'B31', residue 1",
);


for my $tup (#[ 'd', 'JD1,118a'],
#	     ['o', 'fasta'],
#	     ['p', 'JD1,118a,N40'],
#	     ['w', '60'],
#	     ['r', 'B31'],
#	     ['C', '90'],
#	     ['E', 'B31'],
	     ['I', 'B31,1'])
{
    run_bio_program('bioaln', 'test-bioaln.cds', "-$tup->[0] $tup->[1]",
		    "opt-$tup->[0].right", {note=>$notes{$tup->[0]}});
}

note( "Testing other bioaln option-value options" );

%notes = (
    i => "input is a FASTA alignment",
    s => "alignment slice from 80-100",
    P => "Back-align CDS sequence according to protein alignment",
);

my $nuc = test_file_name('test-bioaln-pep2dna.nuc');
for my $triple (['i', 'fasta', 'test-bioaln-pep2dna.nuc'],
		['s', '80,100', 'test-bioaln.aln'],
		['P', $nuc, 'test-bioaln-pep2dna.aln'])
{
    run_bio_program('bioaln', $triple->[2], "-$triple->[0] $triple->[1]",
		    "opt-$triple->[0].right", {note=>$notes{$triple->[0]}});
}


%notes = (
    b => "bootstrap",
    M => "permute-states",
    U => "Make an uppercase alignment",
);


for my $letter (keys %notes) {
    run_bio_program_nocheck('bioaln', 'test-bioaln.cds', "-${letter}",
			    {note=>$notes{$letter}});
}

run_bio_program_nocheck('bioaln', 'test-bioaln.cds', "-R 3",
			    {note=>"resample"});
done_testing();
