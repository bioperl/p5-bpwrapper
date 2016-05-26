#!/usr/bin/env perl
# Copyright (c) 2016 by Weigang Qui Lab

package Bio::BPWrapper;

our $VERSION = '1.02';
use strict; use warnings;

use constant PROGRAM => 'Bio::BPWrapper';

sub show_version() {
    PROGRAM . ", version $Bio::BPWrapper::VERSION";
}

unless (caller) {
    print show_version, "\n";
    print "Pssst... this is a module. See trepan.pl to invoke.\n"
}
1;
