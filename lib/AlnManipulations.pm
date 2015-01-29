=head1 NAME

SeqManipulations - Functions for bioseq

=head1 SYNOPSIS

require B<SeqManipulations>;

=cut

use strict;    # Still on 5.10, so need this for strict
use warnings;
use 5.010;
use Bio::AlignIO;
use Bio::SimpleAlign;
use Bio::LocatableSeq;
use Data::Dumper;
use List::Util qw(shuffle);
use Bio::Align::Utilities qw(:all);

if ($ENV{'DEBUG'}) {
    use Data::Dumper;
}

# Package global variables
my ($in, $out, $aln, %opts, $file, $in_format, $out_format);

## For new options, just add an entry into this table with the same key as in
## the GetOpts function in the main program. Make the key be a reference to
## the handler subroutine (defined below), and test that it works.  
my %opt_dispatch = (
    "avpid" => \&print_avp_id,
    "bootstrap" => \&bootstrap,
    "codon-view" => \&draw_codon_view,
    "delete" => \&del_seqs,
    "nogaps" => \&remove_gaps,
    "length" => \&print_length,
    "match" => \&print_match,
    "numseq" => \&print_num_seq,
    "pick" => \&pick_seqs,
    "refseq" => \&change_ref,
    "slice" => \&aln_slice,
    "uniq" => \&get_unique,
    "varsites" => \&variable_sites,
    "window" => \&avg_id_by_win,
    "concat" => \&concat,
    "conblocks" => \&conserved_blocks,
    "consensus" => \&get_consensus,
    "erasecol" => \&remove_gapped_cols_in_one_seq,
	"aln-index" => \&colnum_from_residue_pos,
	"listids" => \&list_ids,
    "permute-states" => \&permute_states,
    "paml" => \&paml,
    "resample" => \&sample_seqs,
    "shuffle-sites" => \&shuffle_sites,
	"third-sites" => \&third_sites,
	"uppercase" => \&upper_case,
   );

################################################################################
## Subroutines
################################################################################

## TODO Formal testing!

sub initialize {
    my $val = shift;
    %opts = %{$val};

	# This is the format that aln-manipulations expects by default
	my $default_format = "clustalw";

	$file = shift @ARGV || "STDIN";    # If no more arguments were given on the command line,

	# assume we're getting input from standard input

	$in_format = $opts{"input"} || $default_format;

	$in = Bio::AlignIO->new(-format => $in_format, ($file eq "STDIN")? (-fh => \*STDIN) : (-file => $file));

	$aln = $in->next_aln();
	$aln->set_displayname_flat() unless $opts{"noflatname"};

    #### Options which *require an output FH* go *after* this ####
	$out_format = $opts{"output"} || $default_format;
	$out = Bio::AlignIO->new(-format => $out_format, -fh => \*STDOUT);
}

sub write_out {
	$out->write_aln($aln);
}

############################################

sub can_handle {
    my $option = shift;
    return defined($opt_dispatch{$option});
}

sub handle_opt {
    my $option = shift;
#    warn $option, ": Access subroutine:\t", $opt_dispatch{$option}, "\n";
    # This passes option name to all functions
    $opt_dispatch{$option}->($option);
}

sub bootstrap {
	my $replicates = bootstrap_replicates($aln,1);
	$aln = shift @$replicates;
}

sub print_length {
    say $aln->length();
    exit;
}

sub change_ref {
	$aln = $aln->set_new_reference($opts{"refseq"})
}

sub colnum_from_residue_pos {
    my ($id, $pos) = split /\s*,\s*/, $opts{"aln-index"};
    print $aln->column_from_residue_number($id, $pos), "\n";
    exit;
}

sub print_match {
	$aln->match();
}

sub print_num_seq {
    say $aln->num_sequences();
    exit;
}

sub print_avp_id {
    say $aln->average_percentage_identity();
    exit;
}

sub list_ids {
    my @ids;
    foreach my $seq ($aln->each_seq) {
        push @ids, $seq->display_id();
    }
    say join "\n", @ids;
    exit;
}

sub get_unique {
    $aln->verbose(1);
    $aln = $aln->uniq_seq();
}

sub upper_case {
	$aln->uppercase();
}

sub remove_gapped_cols_in_one_seq {
    my $id = $opts{"erasecol"};
    my $nmatch=0;
    my $ref_seq;
    foreach my $seq ($aln->each_seq) {
	if ($seq->id() =~ /$id/) {
	    $nmatch++;
	    $ref_seq = $seq;
	}
    }
    die "Quit. No ref seq found or more than one ref seq!\n" if !$nmatch || $nmatch > 1;
    my ($ct_gap, $ref) = &_get_gaps($ref_seq);
    warn "Original length: " . $aln->length() . "\n";
    if ($ct_gap) {
	my @args;
	foreach my $pos (@$ref) {
	    push @args, [$pos, $pos];
	}
	$aln = $aln->remove_columns(@args);
	warn "New length: " . $aln->length() . "\n";
    } else {
	warn "No gap: " . $aln->length() . "\n";
    }
}

sub _get_gaps {
    my $seq = shift;
    my $seq_str = $seq->seq();
    my @chars = split //, $seq_str;
    my $cts = 0;
    my @pos=();
    for (my $i=0; $i<=$#chars; $i++) {
	if ($chars[$i] eq '-') { 
	    push @pos, $i;
	    $cts++;
	}
    }
    warn "Found " . scalar(@pos) ." gaps at (@pos) on " . $seq->id() . "\n";
    return ($cts, \@pos);
}

sub shuffle_sites {
    my $new_aln = Bio::SimpleAlign->new();
    my $len = $aln->length();
    my $nseq = $aln->num_sequences();
    my %seq_ids;

    die "Alignment contains only one sequence: $file\n" if $nseq < 2;

    my @sites;
    for (my $i=1; $i<=$len; $i++) {
	my ($ref_bases, $ref_ids) = &_get_a_site($i);
	%seq_ids = %{$ref_ids};
	push @sites, $ref_bases;
    }

    @sites = shuffle(@sites);

    my @order;
    foreach my $site (@sites) {
	my $char = $site->[0];
	push @order, $char->{pos};
    }
    print STDERR "Shuffled site order:\t", join(",", @order);
    print STDERR "\n";

    foreach my $id (sort keys %seq_ids) {
	my $seq_str;
	foreach my $aln_site (@sites) {
	    foreach my $char (@$aln_site) {
		$seq_str .= $char->{nt} if $char->{id} eq $id;
	    }
	}

	my $loc_seq = Bio::LocatableSeq->new(
	    -seq   => $seq_str,
	    -id    => $id,
	    -start => 1,
	   );	

        my $end = $loc_seq->end;
        $loc_seq->end($end);

	$new_aln->add_seq($loc_seq);
    }
    $aln = $new_aln;
}

sub conserved_blocks {
    my $len=$aln->length();
    my $nseq = $aln->num_sequences();
    my $min_block_size = $opts{"conblocks"};
    my %seq_ids;

    die "Alignment contains only one sequence: $file\n" if $nseq < 2;

    my (@blocks, $block);
    my $in_block=0;
    for (my $i=1; $i<=$len; $i++) {
	my ($ref_bases, $ref_ids) = &_get_a_site($i);
	%seq_ids = %{$ref_ids};
	my $is_constant = &_is_constant(&_paste_nt($ref_bases));
	if ($in_block) { # previous site is a contant one
	    if ($is_constant) {
		$block->{length} ++;
		my @sites = @{$block->{sites}};
		push @sites, $ref_bases;
		$block->{sites} = \@sites;
		if ($i == $len) {
		    warn "Leaving a constant block at the end of alignment: $i\n";
		    push @blocks, $block if $block->{length} >= $min_block_size;
		} 
	    } else {
	    $in_block = 0;
	    push @blocks, $block if $block->{length} >= $min_block_size;
	    warn "Leaving a constant block at $i\n";
	    }
	} else { # previous site not a constant one
	    if ($is_constant) { # entering a block
		warn "Entering a constant block at site $i ...\n";
	    $in_block=1;
		$block = { # start a new block
		    start => $i,
		    length => 1,
		    num_seq => $nseq,
		    sites => [ ($ref_bases) ],
		};
	    }
	}
    }
    
    foreach my $bl (@blocks) {
	my $out = Bio::AlignIO->new(-file=> ">$file" . ".slice-". $bl->{start} . ".aln" , -format=>'clustalw');
	my $block_aln = Bio::SimpleAlign->new();
	foreach my $id (sort keys %seq_ids) {
	    my ($seq_str, $ungapped_start, $ungapped_end);
	    my @sites = @{ $bl->{sites} };
	    for (my $i = 0; $i <= $#sites; $i++) {
		my $ref_chars = $sites[$i];
		foreach my $char (@$ref_chars) {
		    next unless $char->{id} eq $id;
		    $ungapped_start = $char->{ungapped_pos} if $i == 0;
		    $ungapped_end = $char->{ungapped_pos} if $i == $#sites;
		    $seq_str .= $char->{nt}; 
		}
	    }

	    my $loc_seq = Bio::LocatableSeq->new(
		-seq   => $seq_str,
		-id    => $id,
		-start => $ungapped_start,
		-end => $ungapped_end,
		);
	    
	    $block_aln->add_seq($loc_seq);
	}
	$out->write_aln($block_aln);
    }
    exit;
}

sub _paste_nt {
    my $ref = shift;
    my @nts;
    foreach my $char (@$ref) {
	push @nts, $char->{nt};
    }
    return \@nts;
}

sub _get_a_site {
    my $pos = shift;
    my (@chars, %seq_ids);

    foreach my $seq ($aln->each_seq) {
	my $ungapped = 0;
	$seq_ids{ $seq->id() }++;
	my $state;
	for (my $i = 1; $i <= $pos; $i++) {
	    $state = $seq->subseq($i, $i);
	    $ungapped++ unless $state eq '-';
	}

	push @chars, {
	    nt => $seq->subseq($pos, $pos),
	    ungapped_pos => ($state eq '-') ? "gap" : $ungapped++,
	    id => $seq->id(),
	    pos => $pos,
	};
    }

    return (\@chars, \%seq_ids);
}

sub _is_constant {
    my %count;
    my $ref   = shift;
    my @array = @$ref;
    my $constant = 1;

    foreach my $char (@array) {
        $count{$char}++;
    }

    my @keys = keys %count;

    if (@keys > 1) {  
        $constant = 0;
    }

    return $constant;

}

sub variable_sites {
    $aln = $aln->remove_gaps();
    my $new_aln = Bio::SimpleAlign->new();
    my $len=$aln->length();
    my (%seq_ids, @sites);
    
# Goes through each column and takes variable ones
    for (my $i=1; $i<=$len; $i++)
        {
            my ($ref_bases, $ref_ids) = &_get_a_site($i);
            %seq_ids = %{$ref_ids};
            my $is_constant = &_is_constant(&_paste_nt($ref_bases));
            if ($is_constant < 1)
            {
                push @sites, $ref_bases;
            }
        }

# Recreate the object for output
    foreach my $id (sort keys %seq_ids)
    {
        my $seq_str;
            foreach my $aln_site (@sites)
            {
                foreach my $char (@$aln_site)
                {
                    $seq_str .= $char->{nt} if $char->{id} eq $id;
                }
            }

        my $loc_seq = Bio::LocatableSeq->new(
            -seq   => $seq_str,
            -id    => $id,
            -start => 1,
           );

        my $end = $loc_seq->end;
        $loc_seq->end($end);
        $new_aln->add_seq($loc_seq);
        
    }
    
    $aln = $new_aln;
    
}

sub remove_gaps {
    $aln = $aln->remove_gaps();
}

sub get_consensus {
    my $percent_threshold = $opts{"consensus"};
    my $consense          = Bio::LocatableSeq->new(
        -seq   => $aln->consensus_string($percent_threshold),
        -id    => "Consensus_$percent_threshold",
        -start => 1,
        -end   => $aln->length()
   );
    $aln->add_seq($consense);
}

# Function: _del_or_pick
# Desc: Internal function. Generic code for either picking or deleting a
#  sequence from an alignment. Used by del_seqs and pick_seqs.
# Input:
#   $id_list, a user-supplied string consisting of comma-separated seq id values
#   $method, the name of the Bio::SimpleAlign method to use (remove_seq or add_seq)
#   $need_new, a flag indicating whether a new Bio::SimpleAlign object is needed
# Returns: Nothing; uses the $aln global variable

sub _del_or_pick {
    my ($id_list, $method, $need_new) = @_;
    my $new_aln
        = ($need_new)
        ? Bio::SimpleAlign->new()
        : $aln;

    my @selected = split(/\s*,\s*/, $id_list);
    foreach my $seq ($aln->each_seq) {
        my $seqid = $seq->display_id();
        foreach my $id (@selected) {
            next unless $seqid eq $id;
            $new_aln->$method($seq);
        }
    }
    $aln = $new_aln if ($need_new == 1);
}

sub del_seqs {
    _del_or_pick($opts{"delete"}, "remove_seq", 0);
}

sub pick_seqs {
    _del_or_pick($opts{"pick"}, "add_seq", 1);
}

sub aln_slice {    # get alignment slice
    my ($begin, $end) = split(/\s*,\s*/, $opts{"slice"});

    # Allow for one parameter to be omitted. Default $begin to the
    # beginning of the alignment, and $end to the end.
    $begin = 1            if ($begin eq "-");
    $end   = $aln->length if ($end   eq "-");
    $aln = $aln->slice($begin, $end);
}

sub avg_id_by_win {
    my $window_sz = $opts{"window"};

    for my $i (1 .. ($aln->length() - $window_sz + 1)) {
        my $slice = $aln->slice($i, $i + $window_sz - 1);
        my $pi = (100 - $slice->average_percentage_identity()) / 100;
        printf "%d\t%d\t%.4f\n", $i, $i + $window_sz - 1, $pi;
    }
    exit
}

sub column_status {
    my %count;
    my $ref   = shift;
    my @array = @$ref;
    my $st    = {
        gap         => 0,
        informative => 1,
        constant    => 1
    };

    foreach my $char (@array) {
        $count{$char}++;
        $st->{gap} = 1 if $char =~ /[\-\?]/;
    }

    my @keys = keys %count;

    foreach my $ct (values %count) {
        if ($ct < 2) {
            $st->{informative} = 0;    # including gap
            last;
        }
    }

    if (@keys > 1) {                 # variable (including gaps)
        $st->{constant} = 0;
    }

    return $st;
}

sub cal_A {
    my $num = shift;
    my $A   = 0;

    for my $i (1 .. $num - 1) {
        $A += 1 / $i;
    }

    return $A;
}

sub permute_states {
    my $new_aln = Bio::SimpleAlign->new();
    my $len=$aln->length();
    my $nseq = $aln->num_sequences();
    my @seq_ids;

    die "Alignment contains only one sequence: $file\n" if $nseq < 2;

    my @sites;
    my $ref_bases = &_get_a_site_v2();
    foreach my $seq_id (sort keys %$ref_bases) { push @seq_ids, $seq_id }
    for (my $i=1; $i<=$len; $i++) {
    my @bases;
    foreach my $seq_id (keys %$ref_bases) { push @bases, $ref_bases->{$seq_id}->{$i} }
    @bases = shuffle(@bases);
    for (my $j=0; $j<$nseq; $j++) { $ref_bases->{$seq_ids[$j]}->{$i} = $bases[$j] }
    }

    foreach my $id (@seq_ids) {
    my $seq_str;
    for (my $i=1; $i<=$len; $i++) {
        $seq_str .= $ref_bases->{$id}->{$i};
    }

    my $loc_seq = Bio::LocatableSeq->new(
        -seq   => $seq_str,
        -id    => $id,
        -start => 1,
       );  

        my $end = $loc_seq->end;
        $loc_seq->end($end);

    $new_aln->add_seq($loc_seq);
    }
    $aln = $new_aln;
}

sub _get_a_site_v2 {
    my %seq_ids;
    my $len = $aln->length();
    foreach my $seq ($aln->each_seq) {
    my $id = $seq->id();
    for (my $i = 1; $i <= $len; $i++) {
        $seq_ids{$id}{$i} = $seq->subseq($i, $i);
    }
    }
    return (\%seq_ids);
}

sub third_sites {
    my $new_aln = Bio::SimpleAlign->new();
    my $len=$aln->length();
    my $nseq = $aln->num_sequences();
    my @seq_ids;

    die "Alignment contains only one sequence: $file\n" if $nseq < 2;

    my $ref_bases = &_get_a_site_v2();
    foreach my $seq_id (sort keys %$ref_bases) { push @seq_ids, $seq_id }

    my @sites;
    for (my $i=3; $i<=$len; $i+=3) {
    push @sites, $i;
    }

    foreach my $id (sort @seq_ids) {
    my $seq_str;
    foreach my $aln_site (@sites) {
        $seq_str .= $ref_bases->{$id}->{$aln_site};
    }

    my $loc_seq = Bio::LocatableSeq->new(
        -seq   => $seq_str,
        -id    => $id,
        -start => 1,
       );  

        my $end = $loc_seq->end;
        $loc_seq->end($end);

    $new_aln->add_seq($loc_seq);
    }
    $aln = $new_aln;
}

sub flag_sites {
    my $length = shift;
    my $flags;
    for (my $i = 1; $i <= $length; $i++) {    # 2. flag the variable sites
        my @char = ();
        foreach my $seq ($aln->each_seq) {
            push @char, $seq->subseq($i, $i);
        }

        my $status = column_status(\@char);

        # Omitting gaps, not interested in variable sites
        if ($opts{"nogaps"} && !$opts{"var"}) {
            if   ($status->{gap}) { $flags .= 1; }
            else                    { $flags .= 0; }
        }
        else {    # If extracting variable sites, but excluding gaps
            if ($status->{gap} && $opts{"nogaps"}) { $flags .= 0; }
            elsif ($status->{constant}) { $flags .= 0; }
            elsif (!$status->{informative} && $opts{"inform"}) {
                $flags .= 0;
            }
            else { $flags .= 1; }
        }
    }

    return $flags;
}

sub sample_seqs {

# If option was given with no number, take the integer part of num_sequences/2
# Its OK to use int() here (especially since we want to round towards 0)
    my $num_seqs = $aln->num_sequences;
    my $sample_size
        = ($opts{"resample"} == 0) ? int($num_seqs / 2) : $opts{"resample"};

    die
        "Error: sample size ($sample_size) exceeds number of sequences in alignment: ($num_seqs)"
        if ($sample_size > $num_seqs);

    # Use Reservoir Sampling to pick random sequences.
    my @sampled = (1 .. $sample_size);
    for my $j ($sample_size + 1 .. $num_seqs) {
        $sampled[ rand(@sampled) ] = $j
            if (rand() <= ($sample_size / $j));
    }

    warn "Sampled the following sequences: @sampled\n\n";
    my $tmp_aln = $aln->select_noncont(@sampled);
    $aln = $tmp_aln;
}

# For use in draw_codon_view
# Pad display ids with a minimum of 4 spaces using the longest display id
# as a reference point for length. Pass-by-reference, so don't return array.
# Return length of longest id plus padding.
sub pad_display_id {
    my $display_id = shift;
    my $max_len    = shift;

    my $padding = ($max_len - length($display_id));
    $display_id .= " " x $padding;

    return $display_id;
}

# Used by draw_codon_view. Calculates position of final position in alinged
# block, prints the current position there.
sub print_positions {
    my $nuc_count    = shift;
    my $aln_length   = shift;
    my $block_length = 3 * $opts{"codon-view"};
    my $max_id_len   = shift;
    my $num_spaces   = 0;

    my $start_pos = $nuc_count + 1;
    my $last_pos  = 0;
    my $offset    = 0;
    if (($nuc_count + $block_length) >= $aln_length) {
        $last_pos = $aln_length;
        my $diff = $aln_length - $nuc_count;

        # $diff % 3 gives the number of extra non-codon nucleotides
        $offset = $diff + ($diff) / 3 + ($diff % 3) - 2;
    }
    else {
        $last_pos = $nuc_count + $block_length;
        $offset = $block_length + ($block_length) / 3 - 2;
    }

    # -1 since we are also printing the starting position.
    $num_spaces += $offset - 1;

 # $last_pos_len = length of last_pos treated as a string (ie length(335) = 3)
    my $last_pos_len = length($last_pos);

    # Pad $start_pos with $num_blanks blanks if it is shorter than $last_pos
    my $num_blanks = $last_pos_len - length($start_pos);
    $start_pos = " " x $num_blanks . "$start_pos"
        if (length($start_pos) < $last_pos_len);

    for (my $i = 0; $i < $last_pos_len; $i++) {
        print " " x $max_id_len
            . substr($start_pos, $i, 1)
            . " " x ($num_spaces)
            . substr($last_pos, $i, 1) . "\n";
    }
}

sub find_max_id_len {
    my $seqs = shift;
    my @sorted_by_length
        = sort { length $a->display_id <=> length $b->display_id } @$seqs;

    return length $sorted_by_length[-1]->display_id;
}

# Draw a CLUSTALW-like alignment to standard out. Strange formatting errors when
# alignment length not divisible by 3. Does not output an alignment in a
# traditional format.

sub draw_codon_view {
#    my $aln = shift;
    # Is 20 by default. Blocks are measured in CODONS, so mult by 3
    my $block_length = 3 * $opts{"codon-view"};
    my $aln_length   = $aln->length();
    my $num_seqs     = $aln->num_sequences();
    my $min_pad = 4;    # Minimum padding between sequence and ID
    my $seq_matrix;
    my @seqs = ($aln->each_seq);
    my @display_ids;

    # Find longest id length, add id/sequence padding
    my $max_id_len = find_max_id_len(\@seqs);

    # id length includes padding
    $max_id_len += $min_pad;

    # Extract display_ids and sequences from AlignIO object.
    foreach my $seq (@seqs) {
        my @seq_str = split '', $seq->seq();
        push @$seq_matrix, \@seq_str;
        push @display_ids, $seq->display_id;

       # Pad display ids so that space between them and sequence is consistent
        $display_ids[-1] = pad_display_id($display_ids[-1], $max_id_len);
    }

    my $nuc_count = 0;

    # Loop over each sequence.
    for (my $i = 0; $i < $num_seqs; $i++) {

        # Print count at end of block when we are starting out a new block
        if ($i == 0) {
            print_positions($nuc_count, $aln_length, $max_id_len);
        }

        # Loop over nucleotides
        for (my $j = $nuc_count; $j < $aln_length; $j++) {

       # When we're starting, or starting a new block, print the display id's.
            print $display_ids[$i] if ($j % $block_length == 0);

            print "$$seq_matrix[$i]->[$j]";
            print " " if ((($j + 1) % 3) == 0);

            # When we've reached the end of the alignment or a block
            if (  ($j + 1 == $aln_length)
                || ((($j + 1) % $block_length) == 0))
            {

              # If this is the last sequence, save the ending (next) position.
                if ($i + 1 == $num_seqs) {
                    $nuc_count = $j + 1;
                }

                # Otherwise, start on the next line.
                else {
                    print "\n";
                }

                # In either case, need to exit this loop.
                last;
            }
        }    # END for LOOP OVER NUCLEOTIDES

     # Finish if we've reached the end of the alignment, and the last sequence
        if (($i + 1 == $num_seqs) && ($nuc_count == $aln_length)) {
            print "\n";
            last;
        }

      # If we haven't reached the end of the alignment, but we've run through
      # all sequences, print final block position and start at first sequence.
        elsif (($i + 1 == $num_seqs) && ($nuc_count < $aln_length)) {
            $i = -1
                ;  # Always increments after a loop; next increment sets to 0.
            print "\n\n";
        }
    }    # END for LOOP OVER SEQUENCES

  # Can't let script terminate normally: produces traditional alignment output
    exit 0;
}

1;
