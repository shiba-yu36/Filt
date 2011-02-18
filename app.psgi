#!/Users/cside/perl5/perlbrew/bin/perl

use strict;
use warnings;

use utf8;
use Encode;

use Data::Dumper;
use YAML::Syck;
use Perl6::Say;
sub p { my @s = @_; if (scalar @s >= 2) { warn Dumper $_ for @s; } else { warn Dumper @s; } }



# scrape feed
# parse
# filter
#


use lib glob 'modules/*/lib';
use lib glob 'extlib/*/lib';

use UNIVERSAL::require;
use Plack::Builder;
use Path::Class;
use File::Basename qw(dirname);

use Niro;

my $handler = \&Niro::run;

builder {
    enable "Plack::Middleware::Static",
        path => qr{^//?static/}, root => dirname(__FILE__) . '/../';
    $handler;
};


