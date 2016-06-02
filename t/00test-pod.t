#!/usr/bin/env perl
use strict; use warnings;
use Test::More;
use File::Spec;
use File::Basename;

eval "use Test::Pod 1.44";
plan skip_all => "Test::Pod 1.44 required for testing POD" if $@;

my $bindir=File::Spec->catfile(dirname(__FILE__), '../bin');
my $blib=File::Spec->catfile(dirname(__FILE__), '../blib');

my @poddirs = qw( ../blib ../bin );
all_pod_files_ok($blib, $bindir);
