use strict;
use warnings;
use Encode;
use utf8;
use FindBin;
use lib "$FindBin::Bin/../lib";
use WWW::Station::API;

my $station = WWW::Station::API->new(pref_id => 3);
use Data::Dumper;
print Dumper $station->station;




