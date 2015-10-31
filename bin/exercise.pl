#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);

main();

sub main {
	my $root = '.';
	my %opt;
	GetOptions(\%opt, 'list') or usage();
	if ($opt{list}) {
		opendir my $dh, $root or die;
		while (my $entry = readdir $dh) {
			next if $entry =~ /^\./ or not -d $entry;
			next if $entry eq 't';
			next if $entry eq 'bin';
			say $entry;
		}
		exit;
	}
	usage() if @ARGV != 1;
	my $exercise = shift @ARGV;
	$exercise =~ s{\/$}{};
	die "Exercise '$exercise' does not exist\n" if not -d $exercise;
	#say "Checking $exercise";
	##unshift @INC, $exercise;
	##eval "use Exercise";
	#die $@ if $@;
	#my $e = Exercise->new(
	#	root         => $root,
	#	exercise     => $exercise,
	#	solution_dir => $ENV{PM} ? "$root/$exercise/solution" : $root,
	#);
	#$e->setup;
	#$e->check_files;
	#$e->check_runs;
	#$e->check;
	say "DONE     $exercise";
}

sub usage {
	print STDERR <<"END";
Usage: $0 EXERCISE
     --list
END
	exit;
}
