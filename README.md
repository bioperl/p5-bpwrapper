# bp-utils 
Provides convenient command-line access to popular BioPerl classes (e.g., Bio::SeqIO, Bio::Seq; Bio::SimpleAlign) so one does not need to write full-blown scripts for routine manipulations of sequences and alignments.

# Dependencies
* Perl 5.10.0
* BioPerl

# Install & Test
* Go to repository: https://github.com/bioperl/bp-utils
* Download current release: bp-utils-current-release.tar.gz
* Unzip and untar: tar -zxf bp-utils-current-release.tar.gz
* Add "bp-utils" directory to your $PATH: export PATH=$PATH:/path/to/bputils (add to .bashrc or .bash_profile to make it permanent)
* Run test scripts: "./Test-bioseq" and "./Test-bioaln"

# Get Help 
* Run "perldoc": e.g., perldoc bioseq; perldoc bioaln
* Run "--help" or "--man": e.g., bioseq --help; bioaln --help
* A help file with use cases is maintained at: [Bioutils](http://diverge.hunter.cuny.edu/labwiki/Bioutils)

# Developers & Contact
* Yozen Hernandez
* Pedro Pagan
* Girish Ramrattan 
* Corresonding author: Weigang Qiu, City University of New York, Hunter College  (weigang@genectr.hunter.cuny.edu)

# Release Notes
* Release 1.0. (Feb 10, 2015)
** Contains two utilities with tests: bioseq & bioaln
** To be released: biopop & biotree

