package WWW::Station::API;
use 5.008005;
use strict;
use warnings;
our $VERSION = "0.01";
use Text::CSV;
use FindBin;
use Carp;
use WWW::Station::API::Pref qw/fetch_pref_id get_lines_by_pref/;

sub new{
 my($class,%opt) = @_;
 my $self ={
   pref_id => $opt{pref_id},
 };
 bless $self,$class;
 $self;
}

sub pref_id{
 my $self = shift;
 return $self->{pref_id};
}

sub get_url{
 my $self = shift;
 my $url =  get_lines_by_pref($self->pref_id);
 return @{$url->{line}};
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
 while(my $row = $csv->getline_hr($fh)){
  my $company = {};
  $company->{company_cd} = $row->{company_cd};
  $company->{rr_cd} = $row->{rr_cd};
  $company->{company_name} = $row->{company_name}; 
  $company->{company_name_k} = $row->{company_name_k};
  $company->{company_name_h} = $row->{company_name_h};
  $company->{company_name_r} = $row->{company_name_r};
  $company->{company_url} = $row->{company_url};
  $company->{company_type} = $row->{company_type};
  $company->{e_status} = $row->{e_status};
  $company->{e_sort} = $row->{e_sort};
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
 while(my $row = $csv->getline_hr($fh)){
   my $join = {};
   $join->{line_cd} = $row->{line_cd};
   $join->{station_cd1}  = $row->{station_cd1};
   $join->{station_cd2} = $row->{station_cd2};
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
  while(my $row = $csv->getline_hr($fh)){
   my $line = {};
   $line->{line_cd} = $row->{line_cd};
   $line->{company_cd} = $row->{company_cd};
   $line->{line_name} = $row->{line_name};
   $line->{line_name_k} = $row->{line_name_k};
   $line->{line_name_h} = $row->{line_name_h};
   $line->{line_color_c} = $row->{line_color_c};
   $line->{line_color_t} = $row->{line_color_t};
   $line->{line_type} = $row->{line_type};
   $line->{lon} = $row->{lon};
   $line->{lat} = $row->{lat};
   $line->{zoom} = $row->{zoom};
   $line->{e_status} = $row->{e_status};
   $line->{e_sort} = $row->{e_sort};
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
  while(my $row = $csv->getline_hr($fh)){
   my $station = {};
   $station->{station_cd} = $row->{station_cd};
   $station->{station_g_cd} = $row->{station_g_cd};
   $station->{station_name} = $row->{station_name};
   $station->{station_name_k} = $row->{station_name_k};
   $station->{station_name_r} = $row->{station_name_r};
   $station->{line_cd} = $row->{line_cd};
   $station->{pref_cd} = $row->{pref_cd};
   $station->{post} = $row->{post};
   $station->{add} = $row->{add};
   $station->{lon} = $row->{lon};
   $station->{lat} = $row->{lat};
   $station->{open_ymd} = $row->{open_ymd};
   $station->{close_ymd} = $row->{close_ymd};
   $station->{e_status} = $row->{e_status};
   $station->{e_sort} = $row->{esort};
   push @$station_infos,$station;
 }
 close $fh;
 return $station_infos;
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

