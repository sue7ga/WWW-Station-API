package WWW::Station::API::Pref;
use strict;
use warnings;
use utf8;
use Carp;
use Encode;
use Text::CSV;
use parent qw/Exporter/;
use WWW::Station::API::Provider::Common;
our @EXPORT_OK = qw/fetch_pref_id get_lines_by_pref/;

sub fetch_pref_id{
  @prefs = WWW::Station::API->pref;

 if($arg =~ /\A\d{2}\Z/){
   return $arg;
 }

 return _retrieve_id_by_name($arg,\@prefs);
}

sub _retrieve_id_by_name{
  my($name,$pref) = @_;
 
  foreach my $nef(@$pref){
    foreach my $key(keys %$nef){
      return $key if $nef->{$key} eq $name;
    }
  }

  croak encode_utf8("No such pref:$name");
}

sub get_lines_by_pref{
 my $pref_id = shift;
 my $url = WWW::Station::API::Provider::Common->dispatch('line',$pref_id);
 return $url;
}


1;
