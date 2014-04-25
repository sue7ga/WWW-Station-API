use strict;
use warnings;
use Test::More;

use WWW::Station::API;

my $station = WWW::Station::API->new(pref_id => 14);    

my %linename_stationname = $station->get_stationname_by_prefname('東京都');

use Data::Dumper;

print Dumper \%linename_stationname;

