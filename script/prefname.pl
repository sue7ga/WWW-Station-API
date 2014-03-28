use strict;
use warnings;
use utf8;
use Encode;
use Carp;
use FindBin;
use lib "$FindBin::Bin/../lib";
use WWW::Station::API;

my $station = WWW::Station::API->new(pref_id => 14);

use Data::Dumper;

my @stations = $station->get_url;

foreach my $key(@stations){
  print $key->{station_name2},"\n";
}

