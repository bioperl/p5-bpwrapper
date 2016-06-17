#!/usr/bin/env perl
use rlib '.';
use strict; use warnings;
use Test::More;
use Helper;

my %notes = (
    'nogaps' => 'remove gaps',
    'length' => 'protein sequence length',
    'numseq' => 'number of sequences',
    'revcom' => 'reverse compliment sequence',
    'anonymize' => 'anonymize sequence IDs',
    'break' => 'break into single-sequence files',
    'linearize' => 'linearize fast sequence',
    'removestop' => 'remove stop codons',
);

# test_no_arg_opts('bioseq', 'test-bioseq.nuc', \%notes);

my $opts = [
    ['delete', 'order:2', 'delete by order'],
    ['pick', 'order:2', 'pick 1 sequence by order'],
    ['subseq', '10,20', 'get subsequences'],
    ['translate', '1', 'translate DNA'],
    ['reloop', '3', 'reloop a sequence'],
    ];

my $multi_opts = [
    ["--pick 'order:2,4'",
     'pick-order-2,4.right', 'pick seqs by order delimited by commas'],
    ["--pick 'order:2,4'",
     'pick-order-2-4.right', 'pick seqs by order with range']
    ];

    for my $tuple (@$multi_opts) {
	my ($opts, $check, $note) = @$tuple;
	run_bio_program('bioseq', 'test-bioseq.nuc', $opts, $check, {note => $note});
    }


if ($ENV{'BPWRAPPER_INTERNET_TESTS'}) {
    my $multi_opts = [
	["--fetch 'X83553' --output genbank",
	 'X83553.right', 'fetch Genbank file X8553']
	];

    for my $tuple (@$multi_opts) {
	my ($opts, $check, $note) = @$tuple;
	run_bio_program_nocheck('bioseq', '/dev/null', $opts, {note => $note});
    }
}


done_testing();
