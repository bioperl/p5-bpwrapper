#!/usr/bin/env perl
# 6/27/2018. Codon bias by entropy
# 11/24/2019: weighting & small-sample correction by Sun, Yang, and Xia (2012), MBE
#

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
my $h_genome_wt = 0;
my $n_genome = 0;
foreach my $aa (keys %aas) {
    my @cds = grep {$_->{aa} eq $aa} @cd_cts; 
    my ($Fc, $n, $h) = &cd_entropy(\@cds);
    $h_genome += $h; 
    $h_genome_wt += $n * $h; # more weights to more used amino acids
    $n_genome += $n;
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
    my $h_cds_wt = 0;
    my $n_cds = 0;
    my $effectiveN = 0;
    foreach my $aa (keys %oneLetterAA) {
#	my @cutg_cds = grep {$_->{aa} eq $aa} @cd_cts; 
#	my %seen_cd;
#	foreach (@cutg_cds) { $seen_cd{$_->{codon}}++ }
	my @cds = grep {$_->{aa} eq $aa} @cdCTs; 
#	my %cts;
#	my @pseudo_cts;
	foreach (@cds) { $_->{cts}++ } 		 # add pseudo counts to correct for small sample sizes
#	foreach (keys %seen_cd) { 
#	    if ($cts{$_}) {
#		push @pseudo_cts, {codon => $_, aa => $aa, cts => $cts{$_}++ };
#	    } else {
#		push @pseudo_cts, {codon => $_, aa => $aa, cts => 1};
#	    }
#	}
	my ($Fc, $n, $h) = &cd_entropy(\@cds);
	$h_cds += $h; 
	$h_cds_wt += $n * $h; # more weights to more used amino acids
	$n_cds += $n;
	$effectiveN += 1/$Fc;
    }
    print $seq->id, "\t", $seq->length(), "\t", $numCodons, "\t";
    printf "%.2f\t", $effectiveN;
    printf "%.4f\t", $h_cds - $h_genome;
    printf "%.4f\n",   $h_cds_wt/$n_cds - $h_genome_wt/$n_genome;
}    

exit;

sub cd_entropy {
    my $ref = shift;
    my @cd_obj = @$ref;
    return (1, 0, 0) if @cd_obj <= 1; # single codons (M & W)
    my $sum = 0;
    my $h = 0;
    foreach (@cd_obj) {
	$sum += $_->{cts};
    }
#    return (0, 0) unless $sum > 0;
    foreach (@cd_obj) {
	$_->{rel_freq} = $_->{cts}/$sum;
    }

    my $Fcd = 0; # effective number of codons
    foreach (@cd_obj) {
#	next unless $_->{rel_freq} > 0;
	$h -= $_->{rel_freq} * log($_->{rel_freq})/log(2);
	$Fcd += $_->{rel_freq} ** 2; # Formula #3, 1/homozygosity as diversity
    }
    return ($Fcd, $sum, $h);
}
