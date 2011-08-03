package Persec;
use Modern::Perl;
use parent 'Exporter';
our @EXPORT = qw/ EOS nextChar nextString parse unparsed /;

sub EOS       { m{\G\z}mcg    }
sub WS        { m{\G\s+}mcg   }
sub canWS     { m{\G\s*}mcg   }
sub tailingWS { m{\G\s*\z}mcg }
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
sub unparsed { substr $_,pos($_) }

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
