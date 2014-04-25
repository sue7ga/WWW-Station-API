package WWW::Station::DB;
use 5.008005;
use strict;
use warnings;
use utf8;
our $VERSION = "0.01";

use DBI;

my $dsn = "DBI:mysql:database=Station;host=localhost;port=3000";
our $dbh = DBI->connect($dsn,'suenaga','hirokihH5',{'RaiseError' => 1});

sub company_sql{
 $dbh->do("CREATE TABLE company(company_cd INTEGER,rr_cd INTEGER,company_name VARCHAR(20),company_name_k VARCHAR(20),company_name_r VARCHAR(20),company_url VARCHAR(40),company_type INTEGER,e_status INTEGER,e_sort INTEGER)");
 my $sql = $dbh->prepare($sql);
 my $file = $basic_file."/../Data/company20130120.csv";
 open(my $fh,'<:encoding(utf8)',$file) or croak"can't open";
 my $csv = Text::CSV->new({
  auto_diag => 1, 
  binary => 1, 
 });
 $csv->column_names($csv->getline($fh));
 while(my $row = $csv->getline_hr($fh)){
   $sth->execute($row->{company_cd},$row->{rr_cd},$row->{company_name},$row->{company_name_k},$row->{company_name_h},$row->{company_r});
 }
}

sub line_sql{
 $dbh->do("CREATE TABLE line(line_cd INTEGER,company_c INTEGER,line_name VARCHAR(20),line_name_k VARCHAR(20),line_name_h VARCHAR(20)");
 my $sql = "INSERT INTO line(line_cd,company_c,line_name,line_name_k,line_name_h,line_color_c,line_color_t,line_type,lat,zoom,e_status,e_sort) VARLUES (?,?,?,?,?,?,?,?,?,?,?,?)";
 my $sth = $dbh->prepare($sql);
 my $file = $basic_file."/../Data/line20140303free.csv"; 
}


1;
