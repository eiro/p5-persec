package Persec;
use Modern::Perl;
use parent 'Exporter';
our @EXPORT = qw/
    nextChar nextString
    exhaust
    unparsed forgive_unparsed slurp_unparsed
/;

sub exhaust (&) {
    my @r;
    my $code = shift;
    while ( my @v = $code->() ) { push @r,@v }
    @r
}

sub unparsed { substr $_,pos($_) }
sub forgive_unparsed { pos($_) = length $_ }
sub slurp_unparsed {
    my $r = unparsed;
    forgive_unparsed;
    $r
}

sub WS        { m{\G\s+}cg   }
sub canWS     { m{\G\s*}cg   }
sub tailingWS { m{\G\s*\z}cg }
sub token {
    canWS; my $r = $_ ~~ (shift); canWS;
}

sub nextChar {
    return unless (shift) eq substr $_, pos($_),1;
    pos($_)++;
    1;
}
sub nextString {
    my $l = length ( my $v = shift );
    return 0 unless $v eq substr $_, pos($_), $l;
    pos($_)+=$l;
    1;
}

sub parse {
    local $_ = pop;
    pos($_)  = 0;
    my ( $class, $rule ) = @_;
    $rule ||= 'TOP';
    if ( my @r = $class->$rule ) {
        wantarray
        ? (\@r,unparsed)
        : \@r
    }
    else {
        wantarray
        ? (undef,unparsed)
        : ()
    }
}

1;
