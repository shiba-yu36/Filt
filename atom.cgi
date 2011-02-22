#!/usr/bin/env perl
use strict;

use Plack::Runner;

my $runner = Plack::Runner->new;
$runner->parse_options('-app', 'bin/app.psgi');
$runner->run;
