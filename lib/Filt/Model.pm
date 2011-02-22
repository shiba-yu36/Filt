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
use lib '..';

sub get_feed {
    my ($class) = @_;
    my $res = Filt::Model::Feed->get;
    return undef unless $res;
    Filt::Model::Filter->do($res);
}

1;

