#!/usr/bin/env perl
use rlib '.';
use strict; use warnings;
use Test::More;
use Config;
use Helper;


# option background (background needs special care)
my %notes = (
    'avpid' => 'average percent identity',
    'codon-view' => 'codon view',
    'conblocks' => 'extract conserved blocks',
    'concat' => 'concatenate aln files',
    'dna2pep' => 'CDS alignment to protein alignment',
    'length' => 'length of an alignment',
    'listids' => 'list all sequence IDs',
    'match' => 'match view',
    'noflatname' => 'set display name flat',
    'nogaps' => 'remove gapped sites',
    'numseq' => 'number of aligned sequences',
    'select-third' => 'extract third site',
    'uniq' => 'remove redundant sequences',
    'varsites' => 'show only variable sites',
);

test_no_arg_opts('bioaln', 'test-bioaln.cds', \%notes);

%notes = (
    'aln-index' => "get align column index of seq 'B31', residue 1",
    'concensus' => 'add a 90% consensus sequence',
    'delete' => 'delete sequences JD1, 118a',
    'erasecol' => 'Erase sites gapped at B31',
    'output' => 'output a FASTA alignments',
    'pick' => 'pick sequences JD1, 118a, N40',
    'refseq' => 'change reference (or first) sequence',
    'window' => 'average identifies for sliding windows of 60',
);


my $opts = [
    ['aln-index', 'B31,1'],
    ['consensus', '90'],
    ['delete', 'JD1,118a'],
    ['erasecol', 'B31'],
    ['output', 'fasta'],
    ['pick', 'JD1,118a,N40'],
    ['refseq', 'B31'],
    ['window', '60']
    ];

test_one_arg_opts('bioaln', 'test-bioaln.cds', $opts, \%notes);

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
