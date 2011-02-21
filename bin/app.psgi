#!/Users/cside/perl5/perlbrew/bin/perl
use strict;
use warnings;
use utf8;
use Encode;
use Data::Dumper;
use YAML::Syck;
use Perl6::Say;
sub p { my @s = @_; if (scalar @s >= 2) { warn Dumper $_ for @s; } else { warn Dumper @s; } }
use Path::Class;
use lib file(__FILE__)->dir->parent->subdir('lib')->stringify;

use Filt;
use Plack::Builder;
my $app = \&Filt::run;

builder {
    $app;
};
