#!/usr/bin/env perl
use strict;
use warnings;
use Image::Magick;

sub todigits {
	my ($n, $threshold, $w, $h, $x, $y) = (4,20300,9,18,0,0);
	my $filename = shift @_;
	my @retval = ();
	my $image = Image::Magick->new;

	$image->Read($filename);
	$image->Quantize(colorspace => 'gray');
	$image->Threshold(threshold => $threshold, channel => 'All');
	for (my $i = 0; $i < $n; ++$i) {
		my $digit = $image->Clone();
		$digit->Crop(width => $w, height => $h, x => $x + $i * $w, y => $y);
		$digit->Trim();
		push @retval, $digit;
	}
	return @retval;
}

1;

