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

#JSONm
my $data = $station->get_line_by_prefcd($station->pref_id);
my @line_names = map{$_->{line_name}}@{$data->{line}};

#CSV
my @line_names2 = $station->get_linenames_by_prefcd($station->pref_id);

print scalar @line_names,"\n";
print "--------------------------------------------","\n";
print scalar @line_names2,"\n";


