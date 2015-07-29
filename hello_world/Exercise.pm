package Exercise;
use strict;
use warnings;

use parent 'Exercises';

sub setup {
	my ($self) = @_;
	$self->{exe}   = 'hello_world.pl';
	$self->{files} = [];
	return;
}

sub check {
	my ($self) = @_;

	return 1;
}

1;
