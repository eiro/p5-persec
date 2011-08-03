#! /usr/bin/perl
package ParseMathExpr;
use Persec;
use parent 'Persec';
use Modern::Perl;
use YAML ();

sub expr;

sub op {
    m{\G
        ( [+-/]
        | [*]{1,2}
        )
    }xcg
}

sub value {
    m{\G
        (\d+)
    }xcg and $1
}

sub block {
    nextChar '(' or return;
    my @v = expr or die;
    nextChar ')' or die;
    @v ?  [@v] : ();
}

sub expr {
    ( block || value || return )
    , do {
        if ( my $op = op ) {
            my $expr or die;
            $op, $expr
        }
        else { () }
    }
}


sub TOP { expr }

package main;
use Modern::Perl;
use autodie;
use YAML ();
use Test::More 'no_plan';

for
( [ value =>
    [ [1      => [1      ]]
    , [12     => [12     ]]
    , [100000 => [100000 ]]
    ]
  ]
, [ block =>
    [ [ '(1)'   => [1  ] ]
    , [ '((1))' => [[1]] ]
    ]
  ]
, [ expr  =>
    [ '1 + 5' => [qw< 1 + 5 >]
    ]
  ]
) {
    my ( $rule, $tests ) = @$_;
    for (@$tests) {
        my ( $subject, $expected ) = @$tests;
        my $got = ParseMathExpr->parse( $rule, $subject );
        is_deeply( $got, $expected, "$rule parses $subject")
            or diag YAML::Dump [$got,$expected];
    }
}
