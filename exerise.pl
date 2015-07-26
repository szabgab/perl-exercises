#!/usr/bin/env perl
use strict;
use warnings;
use 5.010;

main();

sub main {
	die "Usage: $0 EXERCISE\n" if @ARGV != 1;
	my $exercise = shift @ARGV;
	$exercise =~ s/\/$//;
	say "Checking $exercise";
	unshift @INC, $exercise;
	eval "use Exercise";
	die $@ if $@;
	my $e = Exercise->new(dir => $ENV{PM} ? "$exercise/solution" : '.');
	$e->setup;
	$e->check_files;
	$e->check;
}



