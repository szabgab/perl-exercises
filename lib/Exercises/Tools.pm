package Exercises::Tools;
use strict;
use warnings;

use Exporter qw(import);
use File::Temp qw(tempdir);

our @EXPORT_OK = qw(get_exercises run slurp slurp_or);

sub get_exercises {
	my ($root) = @_;

	opendir my $dh, $root or die;
	return grep {
			not /^\./
			and -d $_
			and $_ ne 't'
			and $_ ne 'bin'
			and $_ ne 'lib'
			and $_ ne 'blib'
	} readdir $dh;
}

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

