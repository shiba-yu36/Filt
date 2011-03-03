use strict;
use Test::More;
use Filt;
use Plack::Test;
use HTTP::Request::Common;

my $app = \&Filt::run;
test_psgi $app, sub {
    my $cb = shift;

    my $res = $cb->(HTTP::Request->new(GET => "http://localhost/"));
    is $res->code, 200;
    like $res->content, qr/feed xmlns/;
};

done_testing;
