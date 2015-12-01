#!/usr/bin/env perl
use rlib '.';
use strict; use warnings;
use Test::More;
use Helper;
note( "Testing bioaln single-letter options" );
# option b (background needs special care)
for my $letter (qw(a c g l m n u v A B D F L T)) {
    run_bio_program('bioaln', 'test-bioaln.cds', "-${letter}", "opt-${letter}.right");
}
done_testing();
