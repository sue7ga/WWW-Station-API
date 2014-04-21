use strict;
use Test::More;
use Test::Deep;

use WWW::Station::API;
use WWW::Station::API::Pref;
use WWW::Station::API::Provider::Common;

my $station = WWW::Station::API->new(pref_id => 14);
my @row = $station->get_stationname_by_prefname('東京都');

is("@row",'4');

done_testing;



