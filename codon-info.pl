#!/usr/bin/env perl
# 6/27/2018. Codon bias by entropy
# to do: add test by resampling

use strict;
use warnings;
use Bio::CodonUsage::IO;
use Bio::Tools::CodonTable;
use Data::Dumper;
use Bio::SeqIO;
use Bio::Tools::CodonOptTable;

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

my (@cd_cts, %aas);
foreach my $cd (@codons) {
    my $aa = $myCodonTable->translate($cd);
    $aas{$aa}++;
    push @cd_cts, {codon => $cd, aa => $aa, cts => $cdtable->codon_count($cd)};
}

my $h_genome = 0;
foreach my $aa (keys %aas) {
    my @cds = grep {$_->{aa} eq $aa} @cd_cts; 
    $h_genome += &cd_entropy(\@cds);
}

#printf "%.6f\n", $h_genome;

my $cds_file = shift @ARGV;
my $in = Bio::SeqIO->new(-file => $cds_file, -format => 'fasta');
while (my $seq = $in->next_seq()) {
    my $seqobj = Bio::Tools::CodonOptTable->new(
	-seq         => $seq->seq(),
	-genetic_code => 11,
	-alphabet         => 'dna',
	-is_circular      => 0,
	-id => $seq->id(),
	);
    my $myCodons = $seqobj->rscu_rac_table();
    my %oneLetterAA;
    my @cdCTs;
    my $numCodons = 0;
    foreach my $rec (@$myCodons) {
	$numCodons += $rec -> {frequency};
	my $codon = $rec->{codon};
	my $aa = $myCodonTable->translate($codon);
	$oneLetterAA{$aa}++;
	push @cdCTs, {codon => $codon, aa => $aa, cts => $rec->{frequency}};
    }

    my $h_cds = 0;
    foreach my $aa (keys %oneLetterAA) {
	my @cds = grep {$_->{aa} eq $aa} @cdCTs; 
	$h_cds += &cd_entropy(\@cds);
    }
    print $seq->id, "\t", $seq->length(), "\t", $numCodons, "\t";
    printf "%.6f\n", $h_genome - $h_cds;
}    

exit;

sub cd_entropy {
    my $ref = shift;
    my @cd_obj = @$ref;
    return 0 if @cd_obj <= 1; # single codons (M & W)
    my $sum = 0;
    my $h = 0;
    foreach (@cd_obj) {
	$sum += $_->{cts};
    }
    return 0 unless $sum > 0;
    foreach (@cd_obj) {
	$_->{rel_freq} = $_->{cts}/$sum;
    }

    foreach (@cd_obj) {
	next unless $_->{rel_freq} > 0;
	$h -= $_->{rel_freq} * log($_->{rel_freq})/log(2);
    }
    return $h;
}
