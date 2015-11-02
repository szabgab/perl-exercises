use strict;
use warnings;

use Test::More;
use File::Temp qw(tempdir);

use lib 'lib';
use Exercises::Tools qw(get_exercises run slurp);

my $script = 'bin/exercise.pl';
my @exercises = get_exercises('.');

diag "Running on perl $]";

my @cases = (
	{
		name => 'no command line',
		args => [],
		in   => '',
		out  => '',
		err  => qq{Usage: bin/exercise.pl EXERCISE\n     --list\n},
	},
	{
		name => 'incorrect exercise name',
		args => ['other'],
		in   => '',
		out => '',
		err => qq{Exercise 'other' does not exist\n},
	},
	{
		name => 'list',
		args => ['--list'],
		in   => '',
		out => join("\n", @exercises) . "\n",
		err => '',
	},
);

plan tests => 2 * @cases + 2;

# for each exercise
#     for each case in exercise_name/cases
##         copy the files from exercise_name/cases/case/*   to a temporary directory
#         run perl bin/exercise.pl exercise_name
#            check for ??
##         remove all the files from . that do not belong there.
#     for each solution

foreach my $c (@cases) {
	my $args = 'other';
	my $in = '';
	my ($out, $err) = run($^X, $script, @{ $c->{args} }, $c->{in});
	
	is $out, $c->{out}, "stdout of $c->{name}";
	is $err, $c->{err}, "stderr of $c->{name}";
};

foreach my $exercise (@exercises) {
	my $dir = tempdir(CLEANUP => 1);
	$ENV{EXERCISE_DIR} = $dir;
	my ($out, $err) = run($^X, $script, $exercise, '');
	is $out, qq{Checking $exercise\n}, "stdout for $exercise";
	my $expected_err = slurp("$exercise/test_cases/0.err");
	is $err, $expected_err, "stderr for $exercise";

}
#"$root/$exercise/solution"



