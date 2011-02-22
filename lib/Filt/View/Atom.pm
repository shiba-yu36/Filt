package Filt::View::Atom;
use strict;
use warnings;
use utf8;
use parent qw/Filt::Config/;
use Digest::MD5 qw/md5_base64/;
use XML::Atom::Feed;
use XML::Atom::Entry;

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

    my $feed = XML::Atom::Feed->new;

    $feed->title($username . 'のブックマーク');
    $feed->id(id($web_url));

    my $author = XML::Atom::Person->new;
    $author->name($username);
    $feed->author($author);
    $feed->icon(sprintf "http://cdn-ak.www.st-hatena.com/users/%s/%s/profile_s.gif", substr($username, 0, 2), $username);

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

    my $entry = XML::Atom::Entry->new;
    $entry->title($data->{title});
    $entry->id(id($data->{url}));

    $entry->updated($data->{timestamp});

    my $link = XML::Atom::Link->new;
    $link->href($data->{url});
    $entry->link($link);

    my $category = XML::Atom::Category->new;
    $category->term($data->{category});
    $category->label($category_label{$data->{category}});
    $entry->category($category);

    my $content = XML::Atom::Content->new;
    $content->type('xhtml');
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
