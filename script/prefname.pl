use strict;
use warnings;
use utf8;
use Encode;
use Carp;
use FindBin;
use lib "$FindBin::Bin/../lib";
use List::MoreUtils;
use WWW::Station::API;

my $station = WWW::Station::API->new(pref_id => 14);

use Data::Dumper;

my($linename,$stationname) = $station->get_linename_and_stationname_by_prefcd(13);

foreach my $linename(@$stationname){
  print Encode::encode_utf8($linename),"\n";
}
