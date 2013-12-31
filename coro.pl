#!/usr/bin/env perl
use strict;
use warnings;
use Coro;
use AnyEvent::HTTP;
use Data::Dumper;

my @url = ('http://www.amazon.com/', 'http://www.cpan.org','http://www.google.com', 'http://www.baidu.com','http://www.womai.com','http://www.360buy.com');

my @coro;
my $cocurrent = 2;
foreach my $i (1..$cocurrent){
	foreach my $url (@url){
		push @coro, async {
			print "start $url\n";
#http_get $url, cb => Coro::rouse_cb;
			http_head $url, cb => Coro::rouse_cb;
			my @res = Coro::rouse_wait;
			print Dumper @res;
			print "end $url\n";
		};
	};
};

foreach (@coro) {
	print "joining\n";
	$_->join;
	print "joined\n";
};
