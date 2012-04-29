#! /usr/bin/perl
use Modern::Perl;
use autodie;
use YAML ();
use Persec::Combinators qw< :all >;
use Test::More 'no_plan';

$_ = "HAHAHA";
ok
( (not try token qr{ X } )
, "you can try and fail"
);

$_ = "HAHAHA";
my @got = many token qr{ X }; 
ok 
( (not @got)
, "you can try many times") or diag YAML::Dump \@got;

$_ = "HAHAHA";
my ($got) = try token qr{HA};
is ($got, "HA", "you can find something");

$_ = "HAHAHA";
is_deeply
( [try sub { many token qr{HA} } ]
, [qw< HA HA HA >]
, "you can find many things"
);

$_ = "HAHAH";
is_deeply
( [try sub { many token qr{HA} } ]
, [qw< HA HA >]
, "you don't fear the end of the world"
);

$_ = "HAHAHA";
is_deeply
( [exactly 2, token qr{HA}]
, [qw< HA HA >]
, "you're not greedy"
);
is( pos, 4,"ok then" );

# $_ = "HA";
# is_deeply
# ( [at_least 2, token qr{HA}]
# , []
# , "the world is not enought"
# );
# is( pos, 0,"ok then" );
# 
# $_ = "HAHA";
# is_deeply
# ( [at_least 2, token qr{HA}]
# , []
# , "the world is not enought"
# );
# is( pos, 0,"ok then" );

