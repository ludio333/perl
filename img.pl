#!/usr/bin/env perl
use warnings;
use strict;
use LWP::UserAgent;
use HTTP::Cookies;
use Crypt::SSLeay;
use Encode qw(from_to encode decode);
use URI;
use FindBin qw/$Script $Bin/;
use lib "$Bin/lib";
use Cwd;
use strict;
use warnings;
use Selenium::Remote::Driver;
use Test::More;




use constant GET_URL => 'http://group.bj.chinamobile.com/index/index.shtml';

my $cookie_file = 'cookie.txt';

my $ua = LWP::UserAgent->new('ssl_opts' => { 'verify_hostname' => 0 }, agent => 'Mozilla/5.0',
		);
		#env_proxy => 1,keep_alive => 1);

unlink($cookie_file);

my $cookie_jar=HTTP::Cookies->new(file =>$cookie_file,autosave => 1, ignore_discard => 1);
$ua->cookie_jar($cookie_jar);
$ua->protocols_allowed( [ 'http', 'https'] );
push @{ $ua->requests_redirectable }, 'POST';

my $res = $ua->get(GET_URL);
my $tmp = $res->content();
my ($randid) = $tmp =~ m{src="/edsmp/ValidateNum.*?randomid=([^"]+)"}ig;
my $get_url = 'http://group.bj.chinamobile.com/edsmp/ValidateNum?randomid='.$randid;
my $url = URI->new($get_url);      
$url->query_form(                                                                                                                                        
		randomid => $randid,                                                                                                                     
		);                                                                                                                                       
$res = $ua->get($url);                          
my $path = cwd();
my $tmp_file = "$path/lib/tmp.jpg";
open FILE,">",$tmp_file or die "$!";
binmode(FILE);
print FILE $res->content();    
close FILE;

require 'captcha.pl';
require 'convert.pl';

convert($tmp_file);

my $randid2 = captcha($tmp_file) ;

unlink($tmp_file);
print "randid => $randid2\n";

my $post_url = 'http://group.bj.chinamobile.com/edsmp/dispatchLogin.do';
$res= $ua->post($post_url,
		[
		loginmethod => 0,
		id1 => 'SC0BLIHV',
		id2 => 'admin',
		password => 'Mop170.20',
		rnum => $randid2,
		]
	       );

$get_url = "http://group.bj.chinamobile.com/edsmp/LinkmanList.do?agroupid=146743&mphone=18600057550";
$url = URI->new($get_url);
$url->query_form(
		agroupid => '146743',
		mphone => '18600057550',
                );
$res = $ua->get($url);


$post_url = 'http://group.bj.chinamobile.com/edsmp/LinkmanListAjax.do?name=&mphone=18600057550&agroupid=146743';
$res = $ua->post($post_url,
		[
		start => 1,
		size => 10,
		]
		);
my $text = $res->content;
print "$text";
END{
open FN,"cookie.txt";
my $output;
while(<FN>){
	($output) = $_ =~ m{JSESSIONID="(.*?)"}ig 
}
close FN;
print $output."\n";
print $get_url."\n";
}

#my $driver = Selenium::Remote::Driver->new( remote_server_addr => "localhost",
# port => 4444,
# browser_name => "firefox");
#
#$driver->get("/edsmp/LinkmanList.do?agroupid=146743&mphone=18600057550");
#$driver->find_element("刘轩", "link")->click;
#$driver->find_element("//div[\@onclick=\"Dialog.getInstance('Diag02').CancelButton.onclick.apply(Dialog.getInstance('Diag02').CancelButton,[]);\"]", "xpath")->click;
#$driver->quit();
#done_testing();



