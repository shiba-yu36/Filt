package Filt::Model;
use strict;
use warnings;
use Filt::Model::Feed;
use Filt::Model::Filter;

sub get_feed {
    my ($class) = @_;
    my $res = Filt::Model::Feed->get;
    return undef unless $res;
    Filt::Model::Filter->do($res);
}

1;

