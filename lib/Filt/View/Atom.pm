package Filt::View::Atom;
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
use parent qw/Filt::Config/;
use Data::UUID;
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
    $feed->id('urn:uuid:' . uuid($web_url)); #これでいいのか…まあuniqだから良いか

    my $author = XML::Atom::Person->new;
    $author->name($username);
    $feed->author($author);
    # TODO 余裕合ったら：link rel="self" href=""
    $feed->icon(sprintf "http://www.hatena.ne.jp/users/%s/%s/profile_s.gif", substr($username, 0, 2), $username);

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
    $entry->id('urn:uuid:' . uuid($data->{url}));

    $entry->content('Post Body');
    # TODO artist２つって出来たっけ

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
    $content->body('<p>foo<b>bar</b>baz</p>');
    $entry->content($content);

    $entry;
}

sub uuid {
    my $name = shift;
    my $ug = Data::UUID->new;
    $ug->to_string($ug->create_from_name('http://purl.org/atom/ns#', $name));
}

1;
