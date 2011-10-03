package Filt::View::Atom;
use strict;
use warnings;
use utf8;
use parent qw/Filt::Config/;
use Digest::MD5 qw/md5_base64/;
use XML::Feed;
use XML::Feed::Entry;
use DateTime;
use DateTime::Format::W3CDTF;

sub render {
    my ($class, $data) = @_;
    my $self = bless {}, $class;
    my $feed = feed();

    for (@$data) {
        my $entry = entry($_);
        $feed->add_entry($entry);
    }
    $feed->as_xml;
}

sub feed {
    my $username = __PACKAGE__->CONF->{_}->{username};
    my $web_url = 'http://b.hatena.ne.jp/' . $username . '/favorite';

    my $feed = XML::Feed->new('Atom');

    $feed->title($username . 'のブックマーク');
    $feed->id(id($web_url));

    $feed->author($username);

    $feed;
}

sub entry {
    my ($data) = @_;
    my %category_label = (
        social        => '社会',
        economics     => '政治・経済',
        life          => '生活・人生',
        entertainment => 'スポーツ・芸能・音楽',
        knowledge     => '科学・学問',
        it            => 'コンピュータ・IT',
        game          => 'ゲーム・アニメ',
        fun           => 'おもしろ',
    );

    my $entry = XML::Feed::Entry->new('Atom');
    $entry->title($data->{title});
    $entry->id(id($data->{url}));

    my $w3c = DateTime::Format::W3CDTF->new;
    $entry->modified($w3c->parse_datetime($data->{timestamp}));

    $entry->link($data->{url});

    $entry->category($category_label{$data->{category}});

    my $content = $entry->content;
    $content->body(comments(@{$data->{comments}}));
    $entry->content($content);

    $entry;
}

sub comments {
    my @comments = @_;
    join '<br/>', (
        map { $_ =~ s#<a[^>]+>(.+?)</a>#$1#sg; $_; }
        map { $_ =~ s#<span class="tags"[^>]+?>(.+?)</span>#<i>$1</i>#sg; $_; }
        map { $_ =~ s#<a class="username"[^>]+?>(.+?)</a>#<b>$1</b>#s; $_; }
        map { $_ =~ s#<span class="twitter.+?</span>##g; $_; }
        map { $_ =~ s#<span class="click-count.+?</span>##g; $_; }
        map { $_ =~ s#<span class="retweet-count.+?</span>##g; $_; }
        map { $_ =~ s#<div class="tweets.+?</div>##g; $_; }
        map { $_ =~ s#<div class="retweet-images.+?</div>##g; $_; }
        map { $_ =~ s#<span class="hatena-star.+?</span>##g; $_; }
        @comments
    );
}

sub id {
    'tag:hatena.ne.jp,2011:bookmark-' . md5_base64(shift);
}

1;
