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

WriteAll;
