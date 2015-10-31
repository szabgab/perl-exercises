use strict;
use warnings;

use Test::More;
use File::Temp qw(tempdir);

my $script = 'bin/exercise.pl';

#my $args = slurp_or("$dir/$run.args");
#my $in   = slurp_or("$dir/$run.in");

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
		out => "hello_world\n",
		err => '',
	},

);
plan tests => 2 * @cases;

foreach my $c (@cases) {
	my $args = 'other';
	my $in = '';
	my ($out, $err) = run($^X, $script, @{ $c->{args} }, $c->{in});
	
	is $out, $c->{out}, "stdout of $c->{name}";
	is $err, $c->{err}, "stderr of $c->{name}";
};


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

