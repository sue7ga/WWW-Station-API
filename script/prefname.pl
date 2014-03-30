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

my $neardata = $station->get_neardata(11312);


foreach my $key(@{$neardata->{station_join}}){
  print Encode::encode_utf8($key->{station_name1}),"\n";
}
