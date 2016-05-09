use strict;
use Imager;
use Imager::Font;

my $font = Imager::Font->new(
            file    => '/usr/share/fonts/truetype/freefont/FreeMono.ttf',
            color   => 'black',
            size    => 50,
        ) || die Imager->errstr;

my $image = Imager->new(xsize => 500, ysize => 500) or die Imager->errstr;

$image->box(color => 'white', filled => 1) or die $image->errstr;

$image->string( x => 100, y => 100, string => 'Test', font => $font) or die $image->errstr;

$image->write(file => '/tmp/fonttest.png') or die $image->errstr;
