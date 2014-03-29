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

my @line_names = $station->get_line_cd_by_pref(13);

foreach my $name(@line_names){
  print Encode::encode_utf8($name),"\n";
}
