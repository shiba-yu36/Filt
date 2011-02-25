#!/usr/bin/env perl 
use strict;

use Plack::Runner;
use Path::Class;

my $runner = Plack::Runner->new;

my $path = $0;
my $linkpath = readlink $0;
$path = $linkpath if $linkpath;

$runner->parse_options('-app', file($path)->dir->subdir('bin')->file('app.psgi')->stringify);
$runner->run;

