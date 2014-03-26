package WWW::Station::API::Pref;
use strict;
use warnings;
use utf8;
use Carp;
use Encode;
use Text::CSV;
use parent qw/Exporter/;
our @EXPORT_OK = qw/pref/;

my $csv = Text::CSV->new({
  auto_diag => 1,
  binary => 1,
});

1;
