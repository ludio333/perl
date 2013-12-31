#!/usr/bin/env perl
use strict;
use warnings;
use Image::Magick;

sub convert{
	my $file = shift @_;
	my $image = Image::Magick->new;
	$image->Read($file);
	my $example=$image->Clone();
	$example->Label('Resize');
	$example->Resize('1000%');
	$example->Label('Monochrome');
	$example->Quantize(colorspace=>'gray',colors=>2,dither=>'false');
	$example->Label('Despeckle');
	$example->Despeckle();
	$example->Label('Reduce Noise');
	$example->ReduceNoise();
	$example->Label('Resize');
	$example->Resize('10%');
	$example->Label('Crop');
	$example->Crop(width=>36, height=>18, x=>2, y=>0);
	$example->Write($file);
}
1;
