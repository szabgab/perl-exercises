package Exercises;
use 5.010;
use strict;
use warnings;
use IPC::Run qw( run );

sub new {
	my ($class, %args) = @_;

	return bless \%args, $class;
}

sub fail {
	my ($self, $msg) = @_;
	die "$msg\n";
}

sub check_files {
	my ($self) = @_;

	foreach my $file ($self->{exe}, @{ $self->{files} }) {
		$self->fail("File '$file' not found. - You need to create a file called '$file'")
			if not -e "$self->{solution_dir}/$file";
	}
	# if ($^O =~ /\A(darwin|linux)\Z)/) {
	# 	if (not -e $self->{exe}) {
	# 		$self->fail("File '$self->{exe}' not executable. Use chmod to convert it to be executable.")
	# 	}
	# }

	return;
}

sub check_runs {
	my ($self) = @_;

	my $dir = "$self->{root}/$self->{exercise}/runs";
	return if not -d $dir;
	my $run = 0;
	while (1) {
		$run++;
		my @file = glob "$dir/$run.*";
		return if not @file;

		my $args = slurp_or("$dir/$run.args");
		my $in   = slurp_or("$dir/$run.in");
		my ($out, $err);
		run [$^X, $self->{exe}, $args], \$in, \$out, \$err;
		my $expected_err = slurp_or("$dir/$run.err");
		my $expected_out = slurp_or("$dir/$run.out");
	}

	return;
}

sub slurp_or {
	my ($file) = @_;
	return -e $file ? slurp($file) : '';
}

sub slurp {
	my ($file) = @_;
	open my $fh, '<:encoding(UTF-8)', $file or die;
	local $/ = undef;
	my $content = <$fh>;
	close $fh;
	return $content;
}

1;
