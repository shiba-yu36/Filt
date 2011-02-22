use strict;
use Test::More;
use File::Find::Rule;
my @files = File::Find::Rule->file->name('*.pm')->in('lib');
plan tests => scalar @files;

use Path::Class;
use lib file(__FILE__)->dir->parent->subdir('lib')->stringify;

for (@files) {
    s<^lib/><>;
    s<\.pm$><>;
    s</><::>g;
    use_ok $_;
}

done_testing;
