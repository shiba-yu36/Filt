package Filt;
use strict;
use warnings;
use utf8;
use Filt::Model;
use Filt::View::Atom;
use Filt::Request;

sub run {
	my ($env) = @_;

    my $req = Filt::Request->new($env);
    my $content = Filt::Model->get_feed;
    return [404, [], []] unless $content;

    my $res = $req->new_response(200);
    $res->content_type('text/xml; charset=utf-8');
    $res->body( Filt::View::Atom->render($content) );
    $res->finalize;
}

1;
