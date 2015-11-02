#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;
use Getopt::Long qw(GetOptions);
use lib 'lib';
use Exercises::Tools qw(get_exercises);

main();

sub main {
	my $root = '.';
	my %opt;
	GetOptions(\%opt, 'list') or usage();
	if ($opt{list}) {
		for my $name (get_exercises($root)) {
			say $name;
		}
		exit;
	}
	usage() if @ARGV != 1;
	my $exercise = shift @ARGV;
	$exercise =~ s{\/$}{};
	die "Exercise '$exercise' does not exist\n" if not -d $exercise;
	say "Checking $exercise";
	unshift @INC, $exercise;
	eval "use Exercise";
	die $@ if $@;
	my $e = Exercise->new(
		root         => $root,
		exercise     => $exercise,
		solution_dir => ($ENV{EXERCISE_DIR} || $root),
	);
	$e->setup;
	$e->check_files;
	$e->check_test_cases;
	$e->check;
	say 'DONE';
	say "Congratulations. You have completed the '$exercise' exercise.";
}

sub usage {
	print STDERR <<"END";
Usage: $0 EXERCISE
     --list
END
	exit;
}
