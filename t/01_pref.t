use strict;
use Test::More;
use Test::Deep;

use WWW::Station::API;
use WWW::Station::API::Pref;
use WWW::Station::API::Provider::Common;

my $station = WWW::Station::API->new(pref_id => 14);

is($station->get_linenames_by_prefname('宮城県'),4);


done_testing;