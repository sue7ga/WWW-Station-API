use strict;
use Test::More;
use Test::Deep;

use WWW::Station::API;
use WWW::Station::API::Pref;

my $station = WWW::Station::API->new(pref_id => 3);

cmp_deeply $station->file,{
  'hoge' => 'foo',
};

done_testing;