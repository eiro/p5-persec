#! /usr/bin/perl
package ParseMathExpr;
use YAML ();
use Modern::Perl;
use Persec;
use parent 'Persec';

sub opx; sub expr; 

sub op    { m{\G \s* ( [+-/] | [*]{1,2} \s* ) }xcg and $1 }
sub value { m{\G \s* (\d+) \s* }xcg and $1 }
sub block {
    m{\G \s* \( \s* }xcg or return;
    my @v = expr or die unparsed;
    m{\G \s* \) \s* }xcg or die YAML::Dump [ @v, unparsed ];
    @v ?  \@v : ();
}
sub opx  { (op or return () )           ,  expr }
sub expr { ( block || value or return ) ,  opx  }

sub TOP { [expr] }

package main;
use Modern::Perl;
use autodie;
use YAML ();
# say YAML::Dump( ParseMathExpr->parse( '( 5 + 2 * 6 ) / 4 * ( 2 / 5 - 9 + 5 )' ) );

use Test::More 'no_plan';
for
( [ value =>
    [ [1      => [1     ]]
    , [12     => [12    ]]
    , [100000 => [100000]]
    ]
  ]
, [ block =>
    [ [ '(1)'   => [[1  ]] ]
    , [ '((1))' => [[[1]]] ]
    ]
  ]
, [ expr  =>
    [ ['1 + 5' => [qw< 1 + 5 >]]
    ]
  ]
) {
    my ( $rule, $tests ) = @$_;
    for (@$tests) {
        my ( $subject, $expected ) = @$_;
        my ($got) = ParseMathExpr->parse( $rule, $subject );
        is_deeply( $got, $expected, "$rule parses $subject")
            or diag YAML::Dump [$got,$expected];
    }
}
