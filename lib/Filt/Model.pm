package Filt::Model;
use strict;
use warnings;
use Data::Dumper;
sub p { warn Dumper shift; }
use utf8;
use Encode;
use Carp;
use Class::Accessor::Lite (
    rw => [ qw// ],
);
use Filt::Model::Feed;
use Filt::Model::Filter;
use Cache;
use lib '..';

sub get_feed {
    my ($class) = @_;
    #my $cache = Cache->new;
    #my $res = $cache->get('scrape', 60 * 60 * 48);
    my $res = Filt::Model::Feed->get;
    return undef unless $res;
    Filt::Model::Filter->do($res);
}

1;

