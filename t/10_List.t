#! /usr/bin/perl
use Modern::Perl;
use autodie;
use YAML ();

package ParseList;
use Persec;
use parent 'Persec';
use Modern::Perl;

sub element { m{\G ( \w+ ) }xgc and $1 }
sub sep     { m{\G \s* , \s* }xgc }
sub list;
sub list    { (element or return ), (sep) ? list : () } 
sub TOP     {list}

package main;
use Modern::Perl;
use autodie;
use Test::More 'no_plan';

for
( [ 'toto, tata , tutu  ', [qw< toto tata tutu >] ]
, [ ''                   , undef                  ]
, [ '        '           , undef                  ]
, [ 'toto '              , ['toto']               ]
, [ 'toto,'              , ['toto']               ]
, [ 'toto'               , ['toto']               ]
) { my ($subject, $expected) = @$_;
    my $got = scalar ParseList->parse($subject);
    is_deeply( $got , $expected , "")
        or diag YAML::Dump [$got,$expected]
}
