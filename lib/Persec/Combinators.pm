use Persec::Combinators;
use Modern::Perl;
use parent 'Exporter';
our @EXPORT_OK =
qw(
    many at_least exactly try
    back
    rule token
);

our @EXPORT_TAGS =
( all => \@EXPORT_OK
);

sub back { pos($_) = shift }

sub rule {
    my ($regexp) = @_;
    #$regexp ="\\G$regexp";
    sub { /$regexp/cgxms ? {%+} : () } 
}

sub token {
    my ($regexp) = @_;
    $regexp ="\\G$regexp";
    sub { /\G$regexp/cg ? $& : () } 
}

sub try ($) {
    my ( $hypothesis ) = @_;
    my $start = pos($_);

    # let's try it
    my @rewards = $hypothesis->();

    if (@rewards) { @rewards }
    else { back $start; () }
}

sub many {
    my ( $hypothesis ) = @_;
    my (@bank, @rewards);
    my $start = pos($_);
    while (@rewards = try $hypothesis) {
        push @bank, @rewards;
    }
    @bank;
}

sub exactly {
    my ( $times, $hypothesis ) = @_;
    my (@bank, @rewards);
    my $start = pos($_);
    while ( $times-- ) {
        (@rewards = try $hypothesis) or do { back $start; return (); };
        push @bank, @rewards;
    }
    @bank;
}

sub at_least {
    my ( $times, $hypothesis ) = @_;
    exactly(@_)
    , many $hypothesis;
}


