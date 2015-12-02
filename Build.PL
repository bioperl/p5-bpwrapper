#!/usr/bin/env perl

use strict;
use warnings;
use Module::Build;
use Config;
use File::Basename;
use File::Spec;

my $lib = File::Spec->catfile(dirname(__FILE__), 'lib');
unshift @INC, $lib;
require Bio::Wrapper::Version;

my $release_status = ($Bio::Wrapper::Version::VERSION =~ /_/) ?
    'testing' : 'stable';

my $builder = Module::Build->new(
    module_name         => 'Bio::Wrapper', # ??
    add_to_cleanup      => [ 'Bio-Wrapper-*', 'tmp*', '*.got', '*.err'  ],
    create_makefile_pl  => 'passthrough',
    dist_abstract       =>
    'wrappers of popular BioPerl classes (`Bio::SeqIO`, `Bio::Seq`, `Bio::AlignIO`, `Bio::SimpleAlign',
    dist_version_from   => 'lib/Bio/Wrapper/Version.pm',
    # dist_author         => '???',
    # license             => '???gpl',
    needs_compiler      => 0,
    release_status      => $release_status,

    meta_merge => {
        resources => {
            bugtracker  => 'https://github.com/bioperl/bp-utils/issues',
            repository  => 'https://github.com/bioperl/bp-utils',
        }
    },

    configure_requires  => {
        'Module::Build' => '0.4211',

    },
    build_requires => {
        'rlib'                    => '0.02',
    },

    requires => {
        'perl'                              => '5.001000',
        'Bio::Root::Version'                => '1.6.924',
        'rlib'                              => '0.02',
        'version'                           => 0,
    },

    sign                => ($ENV{PERL_MB_NOSIGN} ? 0 : 1),

    test_requires => {
        'Test::More'                        => '0.81',
        'rlib'                              => '0.02',
    },

    );

$builder->create_build_script();
