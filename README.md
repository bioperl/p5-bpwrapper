# Descritpion
bp-utils are command-line utilities that are wrappers of popular BioPerl classes (Bio::SeqIO, Bio::Seq, Bio::AlignIO, Bio::SimpleAlign, etc). The motivation is to relieve BioPerl users from writing full-blown scripts for routine manipulations of sequences, alignments, trees, and others. For common operations of sequences and alignments, bp-utils make it easy to create workflows with a single BASH script containing a combination of bp-utils calls (and no Perl or BioPerl coding is necessary).

Internally, bp-utils follow a "Wrap, don't Write" design principle. That is, we have full faith in the robustness of the BioPerl development framework. As such, bp-utils methods should ALL be wrappers to BioPerl methdos so that exceptions can be handled properly by BioPerl. 

In reality, though, some methods are new and unique to bp-uitls. In the future, all non-wrapper methods in bp-utils should ideally be re-factored as BioPerl class methods. This way, the bp-utils layer could be as thin as possibe and new methods could be added with minimal coding.

# Dependencies
* Perl 5.10.0 or higher
* BioPerl

# Install & Test (assuming a UNIX/Linux-like environment)
* Go to repository: https://github.com/bioperl/bp-utils
* Download current release: bp-utils-current-release.tar.gz
* Unzip and untar: tar -zxf bp-utils-current-release.tar.gz
* Add "bp-utils" directory to your $PATH: export PATH=$PATH:/path/to/bputils (add this line to .bashrc or .bash_profile to make it permanent)
* Run test scripts: "./Test-bioseq" and "./Test-bioaln"

# Get Help
* Run "perldoc": e.g., perldoc bioseq; perldoc bioaln
* Run "--help" or "--man": e.g., bioseq --help; bioaln --help
* A help file with use cases is maintained at: http://diverge.hunter.cuny.edu/labwiki/Bioutils

# Developers & Contact
* Yozen Hernandez
* Pedro Pagan
* Girish Ramrattan 
* Corresonding author: Weigang Qiu, City University of New York, Hunter College  (weigang@genectr.hunter.cuny.edu)

# To Contribute (e.g., add a method)
* We encourage BioPerl developers to add command-line interface to their BioPerl methods by using bp-utils.
* To do so, please contact Weigang Qiu, City University of New York, Hunter College  (weigang@genectr.hunter.cuny.edu)
* For each new mehtod, first pick a long option (--option) and (optionally) a one-letter short (-x) option
* Add one line to the POD Synopsis
* Add to the POD Usage. Note that POD usages are ordered by short names alphabatically
* Add a subroutine to the script itself. Note that subroutines are ordered according to POD usage (alphatically by short names)
* Add a test command to the testing file (add a test file if necessary)

# Release Notes
* Release 1.0. (Feb 10, 2015): Contains two utilities with tests: bioseq & bioaln. To be released: biopop & biotree

