use strict;
use warnings;

use Test::More;
use File::Temp qw(tempdir);

use lib 'lib';
use Exercises::Tools qw(get_exercises);

my $script = 'bin/exercise.pl';
my @exercises = get_exercises('.');

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

{
	my ($out, $err) = run($^X, $script, 'hello_world', '');
	is $out, qq{Checking hello_world\n};
	is $err, qq{File 'hello_world.pl' not found. - You need to create a file called 'hello_world.pl'\n};
}



#is $out, "Checking other\n";
#ok 1;

sub run {
	my $in = pop @_;
	my @args = @_;
	my $dir = tempdir(CLEANUP => 1);
	if (open my $fh, '>', "$dir/in") {
		print $fh $in;
		close $fh;
	}
	system "@args < $dir/in > $dir/out 2> $dir/err";
	my ($out, $err);
	if (open my $fh, '<', "$dir/out") {
		local $/ = undef;
		$out = <$fh>;
	}
	if (open my $fh, '<', "$dir/err") {
		local $/ = undef;
		$err = <$fh>;
	}
	return $out, $err;
}

