package Exercises::Tools;
use strict;
use warnings;

use Exporter qw(import);

our @EXPORT_OK = qw(get_exercises);

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


1;

