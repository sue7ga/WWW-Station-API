package WWW::Station::API;
use 5.008005;
use strict;
use warnings;
use utf8;
our $VERSION = "0.01";
use Text::CSV;
use FindBin;
use Carp;
use WWW::Station::API::Pref qw/fetch_pref_cd get_lines_by_pref get_linedata_by_linecode get_ekidata_by_stationcode get_ekigroupdata_by_stationcode get_neardata_by_linecode/;

use DBI;

sub new{
 my($class,%opt) = @_;
 my $self ={
   pref_cd => $opt{pref_cd},
 };
 bless $self,$class;
 $self;
}

sub pref_cd{
 my $self = shift;
 return $self->{pref_cd};
}

sub get_line_by_prefcd{
 my $self = shift;
 my $prefcd = shift;
 my $linedata = get_lines_by_pref($prefcd);
 return $linedata;
}

sub get_neardata{
 my $self = shift;
 my $linecode = shift;
 my $url = get_neardata_by_linecode($linecode);
 return $url;
}

sub get_linenames_by_prefcd{
 my $self = shift;
 my $pref_cd = shift;
 my @line_cds = $self->get_linecds_by_prefcd($pref_cd);
 my @uniq_line_cds = List::MoreUtils::uniq @line_cds;
 my @line_names = $self->get_linename_by_linecd(\@uniq_line_cds);
 return @line_names;
}

sub get_groupdata_by_stationcd{
 my $self = shift;
 my $station_cd = shift;
 my $url = get_ekigroupdata_by_stationcode($station_cd);
 return $url;
}

#ラインcdから路線名を返す
sub get_linename_by_linecd{
 my $self = shift;
 my $linecd = shift;
 my $line_infos = $self->line;
 my @line_names = map{$_->{line_name}}grep{$_->{line_cd} ~~ @{$linecd}}@$line_infos;
 return @line_names;
}

#都道府県cdから都道府県内のline_cdsを返す
sub get_linecds_by_prefcd{
 my $self = shift;
 my $pref = shift;
 my $station_infos = $self->station; 
 my @line_cds = map{$_->{line_cd}}grep{ $_->{pref_cd} eq $pref}@$station_infos;
 return @line_cds;
}

sub get_stationname_by_prefcd_and_linecd{
  my $self = shift;
  #数値
  my $pref_cd = shift;
  #配列リファレンス
  my $line_cds = shift;
  my $station_infos = $self->station;
  my @station_names = map{$_->{station_name}}grep{ $_->{line_cd} ~~ @$line_cds and $_->{pref_cd} == $pref_cd}@$station_infos;
  return @station_names;
}

sub get_linename_and_stationname_by_prefcd{
 my $self = shift;
 my $prefcd = shift;
 my $station_infos = $self->station;
 my $line_infos = $self->line;
 my @line_cds = map{$_->{line_cd}}grep{$_->{pref_cd} == $prefcd}@$station_infos;
 my @uniq_line_cds = List::MoreUtils::uniq @line_cds;
 my @line_names = map{$_->{line_name}}grep{$_->{line_cd} ~~ @uniq_line_cds}@$line_infos;
 my @stationname = map{$_->{station_name}}grep{$_->{pref_cd} == $prefcd and $_->{line_cd} ~~ @uniq_line_cds}@$station_infos;
 return(\@line_names,\@stationname);
}

sub get_pref_id{
 my $self = shift;
 my $arg  = shift;
 my $pref_cd = fetch_pref_cd($arg);
 return $pref_cd;
}

sub exists_line_by_linenumber{
  my $self = shift;
  my $linenumber = shift;
  my $station = shift;
  my $station_name = get_linedata_by_linecode($linenumber);
  my @station_infos = @{$station_name->{station_l}};
  my @stations;
  foreach my $key(@station_infos){
    push @stations,$key->{station_name};
  }
  my %stations = map{$_ => 1}@stations;
  if($stations{$station}){
    return 1;
  }
}

sub get_url{
 my $self = shift;
 my $url = get_neardata_by_linecode(11302);
 return @{$url->{station_join}};
}

use Data::Dumper;
our $basic_file = $FindBin::Bin;

sub pref{
 my $self = shift;
 my $file = $basic_file."/../Data/pref.csv";
 my $csv = Text::CSV->new({
    auto_diag => 1,
    binary => 1,
 });
 open(my $fh,'<:encoding(utf8)',$file) or croak "can't open";
 $csv->column_names($csv->getline($fh));
 my $pref_infos = [];
 while(my $row = $csv->getline_hr($fh)){
   my $pref = {};
   $pref->{$row->{pref_cd}} = $row->{pref_name};
   push @$pref_infos,$pref;
 }
 close $fh;
 return @{$pref_infos};
}

sub company{
 my $self = shift;
 my $file = $basic_file."/../Data/company20130120.csv";
 my $csv = Text::CSV->new({
   auto_diag => 1,
   binary => 1,
 });
 open(my $fh,'<:encoding(utf8)',$file) or croak "can't open";
 $csv->column_names($csv->getline($fh));
 my $company_infos = [];
 my @keys = qw/company_cd rr_cd company_name company_name_k company_name_h company_name_r company_url company_type e_status e_sort/;
 while(my $row = $csv->getline_hr($fh)){
  my $company = {};
  foreach my $key(@keys){
    $company->{$key} = $row->{$key};
  }
  push @$company_infos,$company;
 }
 return $company_infos;
}

sub join{
 my $self = shift;
 my $file = $basic_file."/../Data/join20140303.csv";
 my $csv = Text::CSV->new({
   auto_diag => 1,
   binary => 1,
 });
 open(my $fh,'<:encoding(utf8)',$file) or croak "can't open";
 $csv->column_names($csv->getline($fh));
 my $join_infos = [];
 my @keys = qw/line_cd station_cd1 station_cd2/;
 while(my $row = $csv->getline_hr($fh)){
   my $join = {};
   foreach my $key(@keys){
    $join->{$key} = $row->{$key};
  }
   push @$join_infos,$join;
 }
 close $fh;
 return $join_infos;
}

sub line{
  my $self = shift;
  my $file = $basic_file."/../Data/line20140303free.csv";
  my $csv = Text::CSV->new({
    auto_diag => 1,
    binary => 1,
  });
  open(my $fh,'<:encoding(utf8)',$file) or croak "can't open";
  $csv->column_names($csv->getline($fh));
  my $line_infos = [];
  my @keys = qw/line_cd company_cd line_name line_name_k line_name_h line_color_c line_color_t line_type lon lat zoom e_status e_sort/;
  while(my $row = $csv->getline_hr($fh)){
    my $line = {};
    foreach my $key(@keys){
     $line->{$key} = $row->{$key};
    }
    push @$line_infos,$line;
  }
  close $fh;
  return $line_infos;
}

sub station{
  my $self = shift;
  my $file = $basic_file."/../Data/station20140303free.csv";
  my $csv = Text::CSV->new({
    auto_diag => 1,
    binary => 1,
  });
  open(my $fh,'<:encoding(utf8)',$file) or croak "can't open";
  $csv->column_names($csv->getline($fh));
  my $station_infos = [];
  my @keys = qw/station_cd station_g_cd station_name station_name_k station_name_r line_cd pref_cd post add lon lat open_ymd close_ymd e_status e_sort/;
  while(my $row = $csv->getline_hr($fh)){
   my $station = {};
   foreach my $key(@keys){
    $station->{$key} = $row->{$key};
   }
   push @$station_infos,$station;
 }
 close $fh;
 return $station_infos;
}

#Database connect

my $dsn = "DBI:mysql:database=Station;host=localhost;port=3000";
my $dbh = DBI->connect($dsn,'suenaga','hirokihH5',{'RaiseError'=>1});

sub company_sql{

}

sub joni_sql{

}

sub pref_sql{

}

sub station_sql{
 $dbh->do("CREATE TABLE station (station_cd INTEGER,station_g_cd INTEGER,station_name VARCHAR(20),line_cd INTEGER,pref_cd INTEGER,post INTEGER,add VARCHAR(20),lon VARCHAR(20),lat VARCHAR(20),open_ymd VARCHAR(20),e_status INTEGER,e_sort INTEGER)");
}

sub line_sql{

}

1;


__END__

=encoding utf-8

=head1 NAME

WWW::Station::API - It's new $module

=head1 SYNOPSIS

    use WWW::Station::API;

=head1 DESCRIPTION

WWW::Station::API is ...

=head1 LICENSE

Copyright (C) sue7ga.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

sue7ga E<lt>sue77ga@gmail.comE<gt>

=cut

