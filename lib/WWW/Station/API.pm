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
use List::MoreUtils;

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

#sub get_linenames_by_prefcd{
# my $self = shift;
# my $pref_cd = shift;
# my @line_cds = $self->get_linecds_by_prefcd($pref_cd);
# my @uniq_line_cds = List::MoreUtils::uniq @line_cds;
# my @line_names = $self->get_linename_by_linecd(\@uniq_line_cds);
# return @line_names;
#}

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
#pref名前からline名と駅名を返す by MySQL

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
our $dbh = DBI->connect($dsn,'suenaga','hirokihH5',{'RaiseError'=>1});

sub station_sql{
  $dbh->do("CREATE TABLE station(station_cd INTEGER,station_g_cd INTEGER,station_name VARCHAR(20),station_name_k VARCHAR(20),station_name_r VARCHAR(20),line_cd INTEGER,pref_cd INTEGER,post VARCHAR(20),address VARCHAR(50),lon VARCHAR(40),lat VARCHAR(20),open_ymd VARCHAR(20),close_ymd VARCHAR(20),e_status INTEGER,e_sort INTEGER)");
  my $sql = "INSERT INTO station(station_cd,station_g_cd,station_name,station_name_k,station_name_r,line_cd,pref_cd,post,address,lon,lat,open_ymd,close_ymd,e_status,e_sort) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  my $sth = $dbh->prepare($sql);
  my $file = $basic_file."/../Data/station20140303free.csv";
  my $csv = Text::CSV->new({
    auto_diag => 1,
    binary => 1,
  });
  open(my $fh,'<:encoding(utf8)',$file) or croak "can't open";
  $csv->column_names($csv->getline($fh));
  while(my $row = $csv->getline_hr($fh)){
     $sth->execute($row->{station_cd},$row->{station_g_cd},$row->{station_name},$row->{station_name_k},$row->{station_name_r},$row->{line_cd},$row->{pref_cd},$row->{post},$row->{add},$row->{lon},$row->{lat},$row->{open_ymd},$row->{close_ymd},$row->{e_status},$row->{e_sort});
  }
}

sub line_sql{
 $dbh->do("CREATE TABLE line(line_cd INTEGER,company_c INTEGER,line_name VARCHAR(20),line_name_k VARCHAR(20),line_name_h VARCHAR(20),line_color_c VARCHAR(20),line_color_t VARCHAR(20),line_type VARCHAR(20),lat DOUBLE,zoom INTEGER,e_status INTEGER,e_sort INTEGER)");
 my $sql = "INSERT INTO line(line_cd,company_c,line_name,line_name_k,line_name_h,line_color_c,line_color_t,line_type,lat,zoom,e_status,e_sort) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)";
 my $sth = $dbh->prepare($sql);
 my $file = $basic_file."/../Data/line20140303free.csv";
 open(my $fh,'<:encoding(utf8)',$file) or croak "can't open";
 my $csv  = Text::CSV->new({
   auto_diag => 1,
   binary => 1,
 });
 $csv->column_names($csv->getline($fh));
 while(my $row = $csv->getline_hr($fh)){
   $sth->execute($row->{line_cd},$row->{company_c},$row->{line_name},$row->{line_name_k},$row->{line_name_h},$row->{line_color_c},$row->{line_color_t},$row->{line_type},$row->{lat},$row->{zoom},$row->{e_status},$row->{e_sort});
 }
}

sub company_sql{
 $dbh->do("CREATE TABLE company(company_cd INTEGER,rr_cd INTEGER,company_name VARCHAR(20),company_name_k VARCHAR(20),company_name_h VARCHAR(20),company_name_r VARCHAR(20),company_url VARCHAR(40),company_type INTEGER,e_status INTEGER,e_sort INTEGER)");
 my $sql = "INSERT INTO company(company_cd,rr_cd,company_name,company_name_k,company_name_h,company_name_r,company_url,company_type,e_status,e_sort) VALUES (?,?,?,?,?,?,?,?,?,?)";
 my $sth = $dbh->prepare($sql);
 my $file = $basic_file."/../Data/company20130120.csv";
 open(my $fh,'<:encoding(utf8)',$file) or croak "can't open";
 my $csv = Text::CSV->new({
    auto_diag => 1,
    binary => 1,
 });
 $csv->column_names($csv->getline($fh));
 while(my $row = $csv->getline_hr($fh)){
  $sth->execute($row->{company_cd},$row->{rr_cd},$row->{company_name},$row->{company_name_k},$row->{company_name_h},$row->{company_name_r},$row->{company_url},$row->{company_type},$row->{e_status},$row->{e_sort});
 }
}

sub join_sql{
  $dbh->do("CREATE TABLE nearstation(line_cd INTEGER,station_cd1 INTEGER,station_cd2 INTEGER)");
  my $sql = "INSERT INTO nearstation(line_cd,station_cd1,station_cd2) VALUES (?,?,?)";
  my $sth = $dbh->prepare($sql);
  my $file = $basic_file."/../Data/join20140303.csv";
  open(my $fh,'<:encoding(utf8)',$file) or croak "can't open";
  my $csv  = Text::CSV->new({
    auto_diag => 1,
    binary => 1,
  });
  $csv->column_names($csv->getline($fh));
  while(my $row = $csv->getline_hr($fh)){
    $sth->execute($row->{line_cd},$row->{station_cd1},$row->{station_cd2});
  }
}

sub pref_sql{
  $dbh->do("CREATE TABLE pref(pref_cd INTEGER,pref_name VARCHAR(20))");
  my $sql = "INSERT INTO pref(pref_cd,pref_name) VALUES (?,?)";
  my $sth = $dbh->prepare($sql);
  my $file = $basic_file."/../Data/pref.csv";
  open(my $fh,'<:encoding(utf8)',$file) or croak "can't open";
  my $csv  = Text::CSV->new({
     auto_diag => 1,
     binary => 1,
  });
  $csv->column_names($csv->getline($fh));
  while(my $row = $csv->getline_hr($fh)){
   $sth->execute($row->{pref_cd},$row->{pref_name});
  }
}

sub get_prefcd_by_prefname{
 my $prefname = shift;
 my $pref_sql = "SELECT pref_cd FROM pref WHERE pref_name = ?";
 my $pref_sth = $dbh->prepare($pref_sql);
 $pref_sth->execute($prefname);
 my $row = $pref_sth->fetchrow_array;
 return $row; #都道府県cd
}

sub arrayref_to_array{
 my $arrayref = shift;
 my @array = ();
 foreach my $key(@$arrayref){
    foreach my $hoge(@$key){
      push @array,@$hoge;
    }
 }
 return @array;
}

sub get_linenames_by_prefname{
 my ($self,$pref_name) = @_;
 my $prefcd = get_prefcd_by_prefname($pref_name);
 my $row_sql = "SELECT l.line_name FROM line AS l JOIN station AS s ON l.line_cd = s.line_cd WHERE s.pref_cd = ?";
 my $row_sth = $dbh->prepare($row_sql);
 $row_sth->execute($prefcd);
 my @row = $row_sth->fetchall_arrayref;
 my @line_names = arrayref_to_array(\@row);
 my @uniq_line_names = List::MoreUtils::uniq @line_names;
 return @uniq_line_names;
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

