package WWW::Station::API::Provider::Common;
use strict;
use warnings;
use Encode;
use utf8;
use Carp;
use JSON;
use parent qw/Exporter/;
our @EXPORT_OK = qw/disptch/;
use constant API_ENDPOINT => 'http://www.ekidata.jp/api';
use LWP::UserAgent;

sub dispatch{
  my $self = shift;
  my $type = shift;
  my $arg = shift;
  my $url;
  if($type eq 'pref'){
    $url = API_ENDPOINT."/p/".$arg.".json";
  }elsif($type eq 'line'){
    $url = API_ENDPOINT."/l/".$arg.".json";
  }elsif($type eq 'station'){
    $url = API_ENDPOINT."/s/".$arg.".json";
  }elsif($type eq 'stationcode'){
    $url = API_ENDPOINT."/g/".$arg.".json";
  }elsif($type eq 'near'){
    $url = API_ENDPOINT."/n/".$arg.".json";
  }
  $self->call($url);
}

use Data::Dumper;

sub call{
  my $self = shift;
  my $url = shift;
  my $ua = LWP::UserAgent->new;
  my $res = $ua->get($url);
  $res->{_content} =~ s/xml.data =//g;
  $res->{_content} =~ s/xml//g;
  $res->{_content} =~ s/;//;
  $res->{_content} =~ s/if\(typeof\(\)==\'undefined\'\)  = {}//g;
  $res->{_content} =~ s/if\(typeof\(.onload\)==\'function\'\) .onload\(.data\);//g;
  my $data = $res->is_success? decode_json($res->{_content}):"";
  return $data;
}

1;
