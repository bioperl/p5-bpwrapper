#!/usr/bin/env perl
use 5.010;

use strict;
use warnings;
use Module::Build;
use Config;
use File::Basename;
use File::Spec;

my $lib = File::Spec->catfile(dirname(__FILE__), 'lib');
unshift @INC, $lib;
require Bio::BPWrapper;

my $release_status = ($Bio::BPWrapper::VERSION =~ /_/) ?
    'testing' : 'stable';

my $builder = Module::Build->new(
    module_name         => 'Bio::BPWrapper',
    add_to_cleanup      => [ 'Bio-BPWrapper-*', 't/check-data/*.got',
                             '*IGS:11.fas', 't/*IGS:11.fas',
			     'test-files/test-bioaln.cds.slice*.aln',
			     'test-bioseq.nuc.sed', 't/test-bioseq.nuc.sed',
			     'test-bioaln.cds.slice*.aln',
			     '*.fas', '*.err',
			     't/check-data/*.err'],
    create_makefile_pl  => 'traditional',
    dist_abstract       =>
    'wrappers of popular BioPerl classes (`Bio::SeqIO`, `Bio::Seq`, `Bio::AlignIO`, `Bio::SimpleAlign',
    dist_version_from   => 'lib/Bio/BPWrapper.pm',
    dist_author         => ['Y. Hernandez', 'P. Pagan',  'G. Ramrattan', 'W.-G. Qiu', 'R. Bernstein'],
    license             => 'perl_5',
    needs_compiler      => 0,
    release_status      => $release_status,

    meta_merge => {
        resources => {
            bugtracker  => 'https://github.com/bioperl/p5-bpwrapper/issues',
            repository  => 'https://github.com/bioperl/p5-bpwrapper',
        }
    },

    configure_requires  => {
        'Module::Build' => '0.4214',

    },
    build_requires => {
        'Path::Tiny'                    => '0.058',
    },

    requires => {
        'perl'                              => 'v5.14',
        'BioPerl'                           => 'v1.7.8',
        #'Bio::Restriction::Analysis'        => 0,
        'Bio::DB::RefSeq'                   => 0,
        'Path::Tiny'                        => '0.058',
    },

    provides => {
	'Bio::BPWrapper' => {
	    file    => 'lib/Bio/Wrapper/AlnManipulations.pm',
	},
	'Bio::BPWrapper::AlnManipulations' => {
	    file    => 'lib/Bio/Wrapper/AlnManipulations.pm',
	},
	'Bio::BPWrapper::PopManipulations' => {
	    file    => 'lib/Bio/Wrapper/PopManipulations.pm',
	},
	'Bio::BPWrapper::SeqManipulations' => {
	    file    => 'lib/Bio/Wrapper/SeqManipulations.pm',
	},
	'Bio::BPWrapper::SeqManipulations' => {
	    file    => 'lib/Bio/Wrapper/Version.pm',
	},
    },

    sign                => ($ENV{PERL_MB_NOSIGN} ? 0 : 1),

    test_requires => {
        'Test::More'                        => '0.81',
        'Path::Tiny'                        => '0.058',
    },

    );

$builder->create_build_script();
