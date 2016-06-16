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

%notes = (
    'delete' => 'delete by order',
    'pick' => 'pick 1 sequence by order',
    'subseq' => 'get subsequences',
    'translate' => 'translate DNA',
    'reloop' => 'reloop a sequence',
);

my $opts = [
    ['delete', 'order:2'],
    ['pick', 'order:2'],
    ['subseq', '10,20'],
    ['translate', '1'],
    ['reloop', '3'],
    ];

test_one_arg_opts('bioseq', 'test-bioseq.nuc', $opts, \%notes);

done_testing();
