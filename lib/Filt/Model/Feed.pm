package Filt::Model::Feed;
use strict;
use warnings;
use Data::Dumper;
sub p { warn Dumper shift; }
use utf8;
use Encode;
use Carp;
use Class::Accessor::Lite (
    rw => [ qw/config/ ],
);
use URI;
use Web::Scraper;
use parent qw/Filt::Config/;

sub get {
    my ($class) = @_;
    my $url = "http://b.hatena.ne.jp/"
              . __PACKAGE__->CONF->{_}->{username}
              . "/favorite?threshold="
              . __PACKAGE__->CONF->{_}->{threshold};
    my $scraper = scraper {
        process "ul#bookmarked_user > li", 'entries[]' => scraper {
            process "h3.entry > a.entry-link",
                    title => "TEXT";
            process "h3.entry > a.entry-link",
                    url => ['@href', sub { $_->as_string }];
            process "ul > li.category > a.category-link",
                    category => ['@href', sub { substr $_->path, 10 }];
            process "div.comment > ul.comment > li > a.username",
                    'users[]' => 'TEXT';
            process "div.comment > ul.comment > li > span.timestamp",
                    timestamp => ['TEXT', sub { sprintf "%04d-%02d-%02dT00:00:00Z", $_ =~ m#(\d{4})/(\d{2})/(\d{2})# }];
            process "div.comment > ul.comment > li",
                    'comments[]' => 'HTML';
        };
    };
    my $res = eval { $scraper->scrape(URI->new($url)) };
    return undef if $@;
    $res->{entries};
}

1;
