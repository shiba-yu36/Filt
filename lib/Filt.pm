package Filt;
use strict;
use warnings;
use Data::Dumper;
sub p { warn Dumper shift; }
use utf8;
use Encode;
use Carp;
use lib '..';
use Class::Accessor::Lite (
    rw => [ qw/config/ ],
);
use Filt::Model;
use Filt::View::Atom;
use Filt::Request;

sub run {
	my ($env) = @_;

    my $req = Filt::Request->new($env);
    my $content = Filt::Model->get_feed;
    return [404, [], []] unless $content;

    my $res = $req->new_response(200); # new Plack::Response
    $res->content_type('text/xml; charset=utf-8');
    $res->body( Filt::View::Atom->render($content) );
    $res->finalize;
}

1;
