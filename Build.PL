use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new
( qw{
    module_name Persec
    dist_version_from lib/Persec.pm
    license perl
    }
, dist_author => 'Marc Chantreux <marcc@cpan.org>'
, build_requires => {qw{
	Test::Pod   1.22
	Test::More  0
	YAML        0
    }}
, meta_add => {qw{
    homepage    https://github.com/eiro/p5-persec
    repository  https://github.com/eiro/p5-persec.git
    bugtracker  https://rt.cpan.org/Dist/Display.html?Queue=Persec
    }}
);

$builder->create_build_script();
