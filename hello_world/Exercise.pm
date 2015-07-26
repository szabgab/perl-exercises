package Exercise;
use strict;
use warnings;

use parent 'Exercises';

sub setup {
	my ($self) = @_;
	$self->{files} = ['hello_world.pl'];
	return;
}

sub check {
	my ($self) = @_;

	return 1;
}

1;
