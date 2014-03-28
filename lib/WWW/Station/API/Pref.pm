package WWW::Station::API::Pref;
use strict;
use warnings;
use utf8;
use Carp;
use Encode;
use Text::CSV;
use parent qw/Exporter/;
use WWW::Station::API::Provider::Common;
our @EXPORT_OK = qw/fetch_pref_cd get_lines_by_pref get_linedata_by_linecode get_ekidata_by_stationcode get_ekigroupdata_by_stationcode get_neardata_by_linecode exists_line_by_linenumber/;

sub fetch_pref_cd{
 my $arg = shift;
 my @prefs = WWW::Station::API->pref;
 if($arg =~ /\A\d{2}\Z/){
   return $arg;
 }
 return _retrieve_cd_by_name($arg,\@prefs);
}

sub _retrieve_cd_by_name{
  my($name,$pref) = @_;
  eval{$name = Encode::decode_utf8($name)};
  foreach my $nef(@$pref){
    foreach my $key(keys %$nef){
      return $key if $nef->{$key} eq $name;
    }
  }
  croak encode_utf8("No such pref:$name");
}

sub get_lines_by_pref{
 my $pref_id = shift;
 my $url = WWW::Station::API::Provider::Common->dispatch('pref',$pref_id);
 return $url;
}

sub get_linedata_by_linecode{
 my $linecode = shift;
 my $url = WWW::Station::API::Provider::Common->dispatch('line',$linecode);
 return $url;
}

sub get_ekidata_by_stationcode{
 my $stationcode = shift;
 my $url = WWW::Station::API::Provider::Common->dispatch('station',$stationcode);
 return $url;
}

sub get_ekigroupdata_by_stationcode{
 my $stationcode = shift;
 my $url = WWW::Station::API::Provider::Common->dispatch('stationcode',$stationcode);
 return $url;
}

sub get_neardata_by_linecode{
 my $linecode = shift;
 my $url = WWW::Station::API::Provider::Common->dispatch('near',$linecode);
 return $url;
}

1;

