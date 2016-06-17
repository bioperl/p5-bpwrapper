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

test_no_arg_opts('bioseq', 'test-bioseq.nuc', \%notes);

my $opts = [
    ['delete', 'order:2', 'delete by order'],
    ['pick', 'order:2', 'pick 1 sequence by order'],
    ['subseq', '10,20', 'get subsequences'],
    ['translate', '1', 'translate DNA'],
    ['reloop', '3', 'reloop a sequence'],
    ];

test_one_arg_opts('bioseq', 'test-bioseq.nuc', $opts);

done_testing();
