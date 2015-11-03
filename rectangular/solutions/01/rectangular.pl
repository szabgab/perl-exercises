use strict;
use warnings;

print "Length: ";
my $length = <STDIN>;
chomp $length;

print "Width: ";
my $width = <STDIN>;
chomp $width;

print "The area is ", $length * $width, "\n";

