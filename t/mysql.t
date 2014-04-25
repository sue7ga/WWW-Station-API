use strict;
use warnings;
use Test::More;

use WWW::Station::API;

my $station = WWW::Station::API->new(pref_id => 14);    

my $linenames = $station->get_stationname_by_prefname('東京都');
 
use Data::Dumper;

my @prefcd = $station->get_prefname_by_linename('京王相模原線');

print Dumper @prefcd;