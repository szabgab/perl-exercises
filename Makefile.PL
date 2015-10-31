use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
	NAME         => 'perl5-exercises',
	AUTHOR       => q{Gabor Szabo <szabgab@cpan.org>},
	VERSION      => '0.01',
	ABSTRACT     => 'Perl 5 Exercises',
	( $ExtUtils::MakeMaker::VERSION >= 6.3002
		? ( 'LICENSE' => 'perl' )
		: () ),
	PL_FILES  => {},
	PREREQ_PM => {
	},
	dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
);
