#!/usr/bin/env perl
# 6/28/2018: simulate a cds, keeping the same AA composition, 
#            while drawing codons from CUTG


use strict;
use warnings;
use Bio::CodonUsage::IO;
use Bio::Tools::CodonTable;
use Data::Dumper;
use Bio::SeqIO;
use Bio::Tools::CodonOptTable;
use Algorithm::Numerical::Sample  qw /sample/;
use Math::Random qw /random_permutation/;
use Getopt::Std;
use Bio::Seq;

my %opts;
getopt('n:', \%opts); # how many simulated CDS

########################
# Read CUTG and make a random codon set for each AA
########################
my $cutg_file = shift @ARGV;
my $io = Bio::CodonUsage::IO->new(-file => $cutg_file);
my $cdtable = $io->next_data();
my @bases = qw(A T C G);
my @codons;
for (my $i=0; $i<=3; $i++) {
    my $first = $bases[$i];
    for (my $j=0; $j<=3; $j++) {
	my $second = $bases[$j];
	for (my $k=0; $k<=3; $k++) {
	    my $third = $bases[$k];
	    push @codons, $first . $second . $third;
	}
    }
}

my $myCodonTable  = Bio::Tools::CodonTable->new( -id => 11 );
#print Dumper($cdtable->all_aa_frequencies);

my (@cd_cts, %aas, %aa_cds);
foreach my $cd (@codons) {
    my $aa = $myCodonTable->translate($cd);
    $aas{$aa}++;
    push @cd_cts, {codon => $cd, aa => $aa, cts => $cdtable->codon_count($cd)};
}

foreach my $aa (keys %aas) { # make a permutated codon set for each AA (use CUTG counts)
    my @cds = grep {$_->{aa} eq $aa} @cd_cts;
    my @cd_sets; 
    foreach (@cds) {
	for (my $i=1; $i<=$_->{cts}; $i++) {
	    push @cd_sets, $_->{codon};
	}
    }
    @cd_sets = random_permutation(@cd_sets);
    $aa_cds{$aa} = \@cd_sets;
}

##############################
# generate a random CDS with the same AA sequence
###############################
my $cds_file = shift @ARGV;
my $in = Bio::SeqIO->new(-file => $cds_file, -format => 'fasta');
my $seq = $in->next_seq(); # expect a single seq
my $pep = $seq->translate()->seq();
my @aas = split //, $pep;
my $out_size = $opts{n} || 1;
my $out = Bio::SeqIO->new(-format => 'fasta');
for (my $k = 1; $k <= $out_size; $k++) {
    my $sim_cds = "";
    for (my $i = 0; $i <= $#aas; $i++) {
	my @sampled_cds = sample(-set => $aa_cds{$aas[$i]}); # sample 1 by default
	my $cd_sim = shift @sampled_cds;
	$sim_cds .= $cd_sim;
    }
    my $sim_obj = Bio::Seq->new(-id => $seq->id() . "|sim_" . $k, -seq => $sim_cds);
    $out->write_seq($sim_obj);
}

exit;

