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

my $solutions = 0;
foreach my $exercise (@exercises) {
	my @sol = glob "$exercise/solutions/*";
	$solutions += @sol;
}

plan tests => 2 * @cases + 2 * @exercises + 2 * $solutions;
	
# for each exercise
#     for each case in exercise_name/cases
##         copy the files from exercise_name/cases/case/*   to a temporary directory
#         run perl bin/exercise.pl exercise_name
#            check for ??
##         remove all the files from . that do not belong there.

foreach my $c (@cases) {
	my $args = 'other';
	my $in = '';
	my ($out, $err) = run($^X, $script, @{ $c->{args} }, $c->{in});
	
	is $out, $c->{out}, "stdout of $c->{name}";
	is $err, $c->{err}, "stderr of $c->{name}";
};

my %SKIP = (
	hello_world => {
		'01' => 1,
	},
);

foreach my $exercise (@exercises) {
	my $dir = tempdir(CLEANUP => 1);
	$ENV{EXERCISE_DIR} = $dir;
	my ($out, $err) = run($^X, $script, $exercise, '');
	is $out, qq{Checking $exercise\n}, "stdout for $exercise";
	my $expected_err = slurp("$exercise/test_cases/0.err");
	is $err, $expected_err, "stderr for $exercise";
	my @solutions = map { substr $_, length "$exercise/solutions/" } glob "$exercise/solutions/*";
	foreach my $sol (@solutions) {
		SKIP: {
			skip "Needs 5.10", 2 if $SKIP{$exercise}{$sol} and $] < 5.010;
			$ENV{EXERCISE_DIR} = "$exercise/solutions/$sol";
			my ($out, $err) = run($^X, $script, $exercise, '');
			is $out, qq{Checking $exercise\nDONE\nCongratulations. You have completed the 'hello_world' exercise.\n}, "stdout for solution $sol of $exercise";
			is $err, '', "stderr for solution $sol of $exercise";
		};
	}
}


