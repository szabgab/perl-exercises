package Exercises;
use strict;
use warnings;

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

	foreach my $file (@{ $self->{files} }) {
		$self->fail("File '$file' not found. - You need to create a file called '$file'")
			if not -e "$self->{dir}/$file";
	}
	return;
}

1;

