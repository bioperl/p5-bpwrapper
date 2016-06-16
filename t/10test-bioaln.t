#!/usr/bin/env perl
use rlib '.';
use strict; use warnings;
use Test::More;
use Config;
use Helper;
note( "Testing bioaln single-letter options on test-bioaln.cds" );


my %notes = (
    'avpid' => 'average percent identity',
    'codon-view' => 'codon view',
    'nogaps' => 'remove gapped sites',
    'length' => 'length of an alignment',
    'match' => 'match view',
    'numseq' => 'number of aligned sequences',
    'uniq' => 'remove redundant sequences',
    'varsites' => 'show only variable sites',
    'concat' => 'concatenate aln files',
    'conblocks' => 'extract conserved blocks',
    'dna2pep' => 'CDS alignment to protein alignment',
    'noflatname' => 'set display name flat',
    'listids' => 'list all sequence IDs',
    'select-third' => 'extract third site',
);

# option background (background needs special care)
for my $opt (keys %notes) {
    run_bio_program('bioaln', 'test-bioaln.cds', "--${opt}", "opt-${opt}.right",
			{note=>$notes{$opt}});
}


note( "Testing bioaln option-value options on test-bioaln.cds" );

%notes = (
    'delete' => 'delete sequences JD1, 118a',
    'output' => 'output a FASTA alignments',
    'pick' => 'pick sequences JD1, 118a, N40',
    'window' => 'average identifies for sliding windows of 60',
    'refseq' => 'change reference (or first) sequence',
    'concensus' => 'add a 90% consensus sequence',
    'erasecol' => 'Erase sites gapped at B31',
    'aln-index' => "get align column index of seq 'B31', residue 1",
);


for my $tup (['delete', 'JD1,118a'],
	     ['output', 'fasta'],
	     ['pick', 'JD1,118a,N40'],
	     ['window', '60'],
	     ['refseq', 'B31'],
	     ['consensus', '90'],
	     ['erasecol', 'B31'],
	     ['aln-index', 'B31,1'])
{
    run_bio_program('bioaln', 'test-bioaln.cds', "--$tup->[0] $tup->[1]",
		    "opt-$tup->[0].right", {note=>$notes{$tup->[0]}});
}

note( "Testing other bioaln option-value options" );

%notes = (
    'input' => "input is a FASTA alignment",
    'slice' => "alignment slice from 80-100",
    'pep2dna' => "Back-align CDS sequence according to protein alignment",
);

my $nuc = test_file_name('test-bioaln-pep2dna.nuc');
for my $triple (['input', 'fasta', 'test-bioaln-pep2dna.nuc'],
		['slice', '80,100', 'test-bioaln.aln'],
		['pep2dna', $nuc, 'test-bioaln-pep2dna.aln'])
{
    run_bio_program('bioaln', $triple->[2], "--$triple->[0] $triple->[1]",
		    "opt-$triple->[0].right", {note=>$notes{$triple->[0]}});
}


%notes = (
    'bootstrap' => "bootstrap",
    'permute-states' => "permute-states",
    'uppercase' => "Make an uppercase alignment",
);


for my $opt (keys %notes) {
    run_bio_program_nocheck('bioaln', 'test-bioaln.cds', "--${opt}",
			    {note=>$notes{$opt}});
}

run_bio_program_nocheck('bioaln', 'test-bioaln.cds', "-R 3",
			    {note=>"resample"});
done_testing();
