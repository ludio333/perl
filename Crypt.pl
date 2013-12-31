#!/usr/bin/env perl
use strict;
use warnings;
use Crypt::Blowfish;
use Term::ReadPassword;
$Term::ReadPassword::USE_STARS = 1;
our $password = read_password('password: ');


my $key = $password;
 
if (length($key) % 8 != 0) {
    $key .= "\000"x(8 - length($key) % 8); 
}
 
my $ci = new Crypt::Blowfish $key;
my @content = qw/user passwd/;
for(@content){
my $en = encryp($ci,$_);
print $en,"\n";
my $de = decryp($ci,$en);
print $de,"\n";
}
 
sub encryp{
### encrypt:
	my ($ci,$plain) = @_;
	my $encryp;
	while(my $p = substr($plain, 0, 8)) {
		my $len = length($p);
		if ($len % 8 != 0) {
			$p .= "\000"x( 8 - $len % 8); 
		}   
		$encryp .= $ci->encrypt($p);
		if (length($plain) > 8) {
			$plain = substr($plain, 8)  
		} else {
			last;
		}   
	}
	$encryp = unpack("H*",$encryp);
	return $encryp;
}
 
sub decryp{
### decrypt:
	my ($ci,$encryp) = @_;
	$encryp = pack("H*",$encryp);
	my $decryp;
	my $plain = $encryp;
	while(my $p = substr($plain, 0, 8)) {
		my $len = length($p);
		if ($len % 8 != 0) {
			$p .= "\000"x( 8 - $len % 8); 
		}   
		$decryp .= $ci->decrypt($p);
		if (length($plain) > 8) {
			$plain = substr($plain, 8)  
		} else {
			last;
		}   
	}
	return $decryp;
}
 
#print "encrypt: ", unpack("H*", $encryp), "\n";
#print $encryp,"\n";
#print "decrypt: ", unpack("H*", $decryp), "\n";
#print $decryp,"\n";
#print "decrypt: ($decryp)\n";
