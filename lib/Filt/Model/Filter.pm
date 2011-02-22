package Filt::Model::Filter;
use strict;
use warnings;
use utf8;
use Encode;
use Class::Accessor::Lite (
    rw => [ qw/data/ ],
);
use parent qw/Filt::Config/;

our $AUTOLOAD;

sub do {
    my ($class, $data) = @_;
    my $self = bless { data => $data }, $class;
    $self->filter_by_urls
    ->filter_by_words
    ->filter_by_categories
    ->filter_by_already_bookmarked
    ->filter_by_recent_bookmarked
    ->data
    ;
}

sub AUTOLOAD {
    my ($self) = @_;

    (my $method = $AUTOLOAD) =~ s/.+:://;
    return if $method eq 'DESTROY';

    my %handler = (
        words => sub {
            grep {
                decode_utf8($_[0]->{title}) =~ /$_/i
            }
            split(/,/, decode_utf8 $_[1])
        },
        categories => sub {
            my @corresp = qw/social economics life entertainment knowledge it game fun/;
            grep { $_[0]->{category} eq $_ }
            map { $corresp[$_ - 1]; }
            split(/,/, $_[1])
        },
        urls => sub {
            grep { $_[0]->{url} =~ /$_/i }
            split(/,/,  $_[1])
        },
        already_bookmarked => sub {
            grep { $_ eq __PACKAGE__->CONF->{_}->{username} }
            @{$_[0]->{users}}
        },
        recent_bookmarked => sub {
            $_[0]->{users}->[0] eq __PACKAGE__->CONF->{_}->{username}
        },
    );

    if ($method =~ /^filter_by_(.+)$/o) {
        $self->filter($1, $handler{$1});
    }
}

sub filter {
    my ($self, $key, $cb) = @_;
    my $ignore;
    if ($key) {
        $ignore = __PACKAGE__->CONF->{_}->{'ignore_' . $key} or return $self;
    }
    my @filtered = grep {
        ! scalar( $cb->($_, $ignore) );
    } @{$self->data};
    $self->data(\@filtered);
    $self;
}

1;
