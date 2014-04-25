use strict;
use warnings;
use Test::More;

use WWW::Station::API;

my $station = WWW::Station::API->new(pref_id => 14);    

my @row = $station->get_linenames_by_prefname('東京都');

use Data::Dumper;

print Dumper @row;