#!/usr/bin/env perl
use strict;
use warnings;
use Path::Class;
use lib file(__FILE__)->dir->parent->subdir('lib')->stringify;

use Filt;
use Plack::Builder;
my $app = \&Filt::run;

builder {
    $app;
};
