use inc::Module::Install;

name 'Filt';
all_from 'lib/Filt.pm';

requires 'Plack::Runner';
requires 'Path::Class';
requires 'Plack::Builder';
requires 'Class::Accessor::Lite';
requires 'Digest::MD5';
requires 'Carp';
requires 'Config::Tiny';
requires 'URI';
requires 'Web::Scraper';
requires 'XML::Atom::Feed';
requires 'XML::Atom::Entry';
requires 'XML::Feed';
requires 'XML::Feed::Entry';
requires 'DateTime';
requires 'DateTime::Format::W3CDTF';


test_requires 'Test::More';
test_requires 'File::Find::Rule';
test_requires 'Plack::Test';
test_requires 'HTTP::Request::Common';

tests 't/*.t';

auto_include;

WriteAll;
