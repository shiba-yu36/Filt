package Filt::Config;
use strict;
use warnings;
use Path::Class;
use Config::Tiny;
use parent qw/Class::Data::Inheritable/;
__PACKAGE__->mk_classdata('CONF');
__PACKAGE__->CONF(get_conf());

sub get_conf {
    my $root   = file(__FILE__)->dir->parent->parent;
    my $config = Config::Tiny->read($root->file('filt.conf'));
}

1;

