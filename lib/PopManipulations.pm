
=head1 NAME

PopManipulations - Functions for biopop

=head1 SYNOPSIS

use B<PopMan::Subs>;

=cut

# MK method is broken: change to comma-delimited way of specifying in group and out groups.
use strict;    # Still on 5.10, so need this for strict
use warnings;
use 5.010;
use Bio::AlignIO;
use Bio::Align::DNAStatistics;

#use Bio::PopGen::IO;
use FindBin;                # Find the location of PopGenStatistics
use lib "$FindBin::Bin";    # to use it as a lib path
#use PopGenStatistics;
use Bio::PopGen::Utilities;
use Bio::PopGen::Statistics;
use Bio::PopGen::Population;
#use Algorithm::Numerical::Sample qw(sample);
use List::Util qw(shuffle sum);
#use Math::Random::MT::Auto qw(rand);
#use Statistics::Basic qw(:all);
use Bio::Tools::CodonTable;
use Data::Dumper;

# Package global variables
my ($opts,     $flags,       $aln_file, $aln,         $in,
    $pop,      $sample_size, $stat_obj, @stats,       $sim,
    $sim_type, @ingroups,     @outgroups, $dist_method, $dna_stats,
    $pop_stats, @var_sites, @exgroups, $ingroup, $outgroup, $pop_cds,
    $myCodonTable
);
my $RELEASE = '1.0';

my %opt_dispatch = (
    'distance' => \&print_distance,
    'heterozygosity' => \&print_heterozygosity,
    'mismatch' => \&print_mismatch_distr,
    'pi' => \&print_diversity,
    'stats'    => \&print_stats,
    'segsites' => \&print_num_snps,
    'var_coding' => \&snp_coding,
    'var_noncoding' => \&snp_noncoding,
#    'mutrec' => \&_mutation_or_recombination,
#    'simmk'    => \&_sim_mk,
#    'kaks'     => \&_print_kaks_calc,
);

# The following options cannot be used along with distance or kaks opts
my @popgen_list = qw(stats mismatch simmk);
$myCodonTable  = Bio::Tools::CodonTable->new( -id => 11 );

##################### initializer & option handlers ###################

## TODO DNAStatistics subs

sub initialize {
    ($opts, $flags) = @_;

    $aln_file = shift @ARGV || "STDIN";    # If no more arguments were given on the command line, assume we're getting input from standard input

    my $in_format = $flags->{"input"} // 'fasta';

    if ($aln_file eq "STDIN") { $in = Bio::AlignIO->new(-format => $in_format, -fh => \*STDIN) }  # We're getting input from STDIN
    else                      { $in = Bio::AlignIO->new(-format => $in_format, -file => "<$aln_file") }  # Filename, or '-', was given

    $aln = $in->next_aln; 

    $sample_size = $flags->{"sample_size"} // undef;
#    @ingroups     = split /\s+,\s+/, join ',', @{ $opts->{"ingroup"} }     // undef if $opts->{"ingroup"};;
#    @outgroups    = split /\s+,\s+/, join ',', @{ $opts->{"outgroup"} }    // undef if $opts->{"outgroup"};
#    @exgroups    = split /\s+,\s+/, join ',', @{ $opts->{"exclude"} }    // undef if $opts->{"exclude"};
    $dist_method = $flags->{"dist-method"} // undef;
    if ($opts->{"distance"} || $opts->{"kaks"}) {
        die "Cannot use distance or kaks options together with any of the following: @popgen_list\n" if &_in_list($opts, \@popgen_list);
        $dna_stats = Bio::Align::DNAStatistics->new();
    } else {
        $pop = Bio::PopGen::Utilities->aln_to_population(-alignment => $aln, -include_monomorphic => 1, -site_model => 'all');
        $pop_cds = Bio::PopGen::Utilities->aln_to_population(-alignment => $aln, -include_monomorphic => 0, -site_model => 'codon') if $opts->{"var_coding"};
#        $stat_obj = PopGenStatistics->new();
        $pop_stats = Bio::PopGen::Statistics->new()
    }
}

sub can_handle {
    my $option = shift;
    return defined($opt_dispatch{$option})
}

sub handle_opt {
    my $option = shift;
    # This passes option name to all functions
    $opt_dispatch{$option}->($option)
}

######################## subroutine #############################

sub print_distance {
    my $warn_bad_dist_method;
    local $SIG{__WARN__} = sub { $warn_bad_dist_method .= shift };
    my $dist_matrix = $dna_stats->distance(-align => $aln, -method => $dist_method);
    die "$warn_bad_dist_method\nQuitting on bad distance method...\n" if $warn_bad_dist_method;
    say $dist_matrix->print_matrix
}

sub print_heterozygosity {
    print "Heterozygosity=>\n";
    for my $name ($pop->get_marker_names()) {
        my $marker = $pop->get_Marker($name);
        my @alleles = $marker->get_Alleles();
        my %allele_freqs = $marker->get_Allele_Frequencies();
        push @var_sites, $name;
        printf "\t\t%s\t%.4f\n", $name,  &heterozygosity(\%allele_freqs)
    }
}

sub print_mismatch_distr {
    my $num_seq = $aln->num_sequences();
    my @seqs;
    push @seqs, $_ foreach $aln->each_seq;
    for (my $i = 0; $i < $num_seq - 1; $i++) {
        for (my $j = $i + 1; $j < $num_seq; $j++) {
            my $new = Bio::SimpleAlign->new();
            $new->add_seq($seqs[$i]);
            $new->add_seq($seqs[$j]);
            printf "%.4f\n", (100 - $new->percentage_identity) / 100
        }
    }
}

sub print_diversity {
    printf "%s\t%.4f\n", "Nucleotide diversity =>", $pop_stats->pi($pop)
}

sub snp_coding {
    my @sites = $pop_cds->get_marker_names();
#    warn "total variable sites: ", join ",", @sites, "\n\nTotal=>", scalar(@sites), "\n\n";
    if ( ! scalar @sites ) {
	die "No polymorphic sites: $aln_file\n";
    }

    for my $site ( sort {$a <=> $b} @sites ) {
        my $pop_marker = $pop_cds->get_Marker($site);
	my @alleles = $pop_marker->get_Alleles(); #print $name, "=>\t", Dumper(\@alleles); next;
        next if &_has_gap($site);  # skip gapped sites
        if (scalar @alleles > 2) { warn $site, ": more than 2 alleles.", join (",", @alleles), "\n"; next }  # consider only 2-state polymorphic sites
        my %freqs = $pop_marker->get_Allele_Frequencies; # print $out_aa, "=>", Dumper(\%freqs); next;
        my ($minor, $major, $syn) = &_syn_nonsyn(\%freqs);
	my $snp_site = 3 * $site + &_snp_position($minor->{codon}, $major->{codon});
        say join "\t", ("codon_".$site, $aln_file, $site, $snp_site, $syn, $minor->{codon}, $minor->{aa}, $minor->{freq}, $major->{codon}, $major->{aa}, $major->{freq});
    }
}

#sub print_stats {
#    @stats = _parse_stats();
#    my $len = $aln->length();

#    foreach my $stat (@stats) {
#        $stat = lc($stat);
#        given ($stat) {
#            when (/^(pi)|(theta)$/) { printf "$stat:\t%.6f\n", $stat_obj->$stat($pop, $len) }
#            when ("tajima_d") {       printf "tajima_D:\t%.6f\n", $stat_obj->tajima_D($pop) }
#            when ("mk") { _mk_counts() }
#        }
#    }
#}

sub print_num_snps {
    print "Number of segregating sites =>", "\t", $pop_stats->segregating_sites_count($pop), "\n"
}

sub print_version {
    say "bp-utils release version: ", $RELEASE;
    exit
}

####################### internal subroutine ###########################

sub _snp_position {
    my ($cd1, $cd2) = @_;
    return 1 if substr($cd1, 0, 1) ne substr($cd2, 0, 1);
    return 2 if substr($cd1, 1, 1) ne substr($cd2, 1, 1);
    return 3 if substr($cd1, 2, 1) ne substr($cd2, 2, 1);
}

sub _in_list {
    my ($ref1, $ref2) = @_;
    foreach my $i (%$ref1) {
	foreach my $j (@$ref2) {
	    return 1 if $j eq $j;
	}
    }
    return 0;
}

sub _parse_stats {
    return split(/,/, join(',', @{ $opts->{"stats"} }))
}

sub _best_sample_size {
    my @group = @_;
    # Checks if $sample_size was defined previously.
    # If it was, make sure it does not exceed the size of the group
    # If it was not, use the size of the group
    return $sample_size ? ($sample_size > @group ? @group : $sample_size) : @group
}


sub _mk_counts {
    die "Error: ingroup and outgroup options required when using MK test.\n" unless $ingroup && $outgroup;

    my $in_group  = Bio::PopGen::Population->new();
    my $out_group = Bio::PopGen::Population->new();
    my (@out, @in);
    for my $ind ($pop->get_Individuals) {
        push @in,  $ind if $ind->unique_id =~ /^$ingroup/;
        push @out, $ind if $ind->unique_id =~ /^$outgroup/
    }

    my @in_shuffled  = shuffle @in;
    my @out_shuffled = shuffle @out;
    my $size         = _best_sample_size(@in_shuffled);    # ingroup size
    my @in_sample = sample(-set => \@in_shuffled, -sample_size => $size);
    $size = _best_sample_size(@out_shuffled);              # outgroup size

    my @out_sample = sample(-set => \@out_shuffled, -sample_size => $size);

    $in_group->add_Individual(@in_sample);
    $out_group->add_Individual(@out_sample);

    my $mk1 = $stat_obj->mcdonald_kreitman($in_group, $out_group);

    #    my $mk2 = $stat_obj->mcdonald_kreitman($out_group, $in_group);
    say join "\t", ($mk1->{poly_N}, $mk1->{fixed_N}, $mk1->{poly_S}, $mk1->{fixed_S})
}

sub _has_gap { # internal methods
    my $pos = shift @_;
    foreach my $seq ($aln->each_seq) {
        return 1 if $seq->subseq(3*$pos+1, 3*$pos+3) =~ /-/;
    }
    return 0;
}

sub _syn_nonsyn {
    my $ref = shift;
    my %fr = %$ref;

    my ($codon1, $codon2) = sort { $fr{$a} <=> $fr{$b} } keys %fr;
    my ($aa1, $aa2) = ($myCodonTable->translate(uc($codon1)), $myCodonTable->translate(uc($codon2)) );

    my $minor = {
	'codon' => uc($codon1),
	'aa' => $aa1,
	'freq' => sprintf "%.4f", $fr{$codon1}
    };

    my $major = {
	'codon' => uc($codon2),
	'aa' => $aa2,
	'freq' => sprintf "%.4f", $fr{$codon2}
    };
    my $syn = $aa1 eq $aa2 ? 1 : 0;
    return ($minor, $major, $syn);
}


=begin
    local $@;
    my $results = eval { $dna_stats->$call(@arg_list) };
    die "Encountered $@\n" if $@;
    for my $an (@$results) {
        say "comparing " . $an->{'Seq1'} . " and " . $an->{'Seq2'}
            unless $calc_type eq "average";
        for (sort keys %$an) {
            next if /Seq/;
            printf("%-9s %.4f \n", $_, $an->{$_})
        }
        say "\n"
    }
=cut


1;

=head1 REQUIRES

Perl 5.010, BioPerl

=head1 SEE ALSO

  perl(1)

=head1 AUTHORS

 Weigang Qiu at genectr.hunter.cuny.edu
 Yözen Hernández yzhernand at gmail dot com

=cut
