# captcha.pl
require 'todigits.pl';
use Image::Imlib2;
use Image::Seek qw(loaddb add_image query_id);
 
my $dbname = 'captcha.db';
 
sub captcha {
    my $tempfile = "/tmp/captcha[$$]" . time . '.png';
    my @digits = todigits(@_);
    my $retval = '';
 
    for my $digit (@digits) {
        $digit->Write($tempfile);
        add_image(Image::Imlib2->load($tempfile), -1);
        my @result = query_id(-1, 2);
        $retval .= $result[0]->[0] + $result[1]->[0] - -1;
#        remove_id(-1);
    }
    unlink $tempfile;
 
    return $retval;
}
 
loaddb($dbname);
1;
