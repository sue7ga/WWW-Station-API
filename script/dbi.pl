use strict;
use warnings;
use utf8;
use Encode;
use Carp;
use FindBin;
use lib "$FindBin::Bin/../lib";
use List::MoreUtils;
use WWW::Station::API;

my $station = WWW::Station::API->new(pref_cd => 13);
use Data::Dumper;

my @row = $station->get_linenames_by_prefname('神奈川県');

print "@row";


