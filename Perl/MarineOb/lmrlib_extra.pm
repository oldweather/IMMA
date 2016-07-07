# Extra functions in the spirit of the lmrlib library.
#
# lmrlib contains methods for most data conversion operations needed
# to get early marine observations into IMMA format. To keep lmrlib
# strictly parallel to the Fortran version, additional or improved
# methods are put in this module instead.

package MarineOb::lmrlib_extra;

use strict;
use warnings;

@MarineOb::lmrlib_extra::ISA       = ('Exporter');
@MarineOb::lmrlib_extra::EXPORT_OK = qw(wind_direction_in_degrees
 direction_average);

#------------------------------------------------------------------------
# ix32dd and ixdcdd give wind directions for a 32-point compass - the EIC
# observations include half and quarter point bearing codes. This function
# converts bearing codes into degrees.
# 'x' stands for 'by' 250 is 'a quarter', 500 'half' and 750 'three quarters',
# so 'North by East half East' is nxe500e for example.
# The fractional point directions can have multiple names (nne250e and
# nexn750n are the same direction) - not all possible names are yet
# included.
sub wind_direction_in_degrees {
    my $ws = lc(shift);    # wind direction string
    $ws =~ s/^\s*//;       # Strip leading blanks
    $ws =~ s/\s*$//;       # Strip trailing blanks
    my %Directions = (
        n        => 360,
        n250e    => 2.8125,
        n500e    => 5.625,
        n750e    => 8.4375,
        nxe      => 11.25,
        nxe250e  => 14.0625,
        nxe500e  => 16.875,
        nxe750e  => 19.6875,
        nne      => 22.5,
        nne250e  => 25.3125,    # Navy style
        nexn750n => 25.3125,    # Merchant style
        nne500e  => 28.125,
        nexn500n => 28.125,
        nne750e  => 30.9375,
        nexn250n => 30.9375,
        nexn     => 33.75,
        ne750n   => 36.5625,
        ne500n   => 39.375,
        ne250n   => 42.1875,
        ne       => 45,
        ne250e   => 47.8125,
        ne500e   => 50.625,
        ne750e   => 53.4375,
        nexe     => 56.25,
        nexe250e => 59.0625,
        nexe500e => 61.875,
        nexe750e => 64.6875,
        ene      => 67.5,
        ene250e  => 70.3125,
        ene500e  => 73.125,
        ene750e  => 75.9375,
        exn      => 78.75,
        e750n    => 81.5625,
        e500n    => 84.375,
        e250n    => 87.1875,
        e        => 90,
        e250s    => 92.8125,
        e500s    => 95.625,
        e750s    => 98.4375,
        exs      => 101.25,
        exs250s  => 104.0625,
        exs500s  => 106.875,
        exs750s  => 109.6875,
        ese      => 112.5,
        ese250s  => 115.3125,
        ese500s  => 118.125,
        sexe500e => 118.125,
        ese750s  => 120.9375,
        sexe     => 123.75,
        se750e   => 126.5625,
        se500e   => 129.375,
        se250e   => 132.1875,
        se       => 135,
        se250s   => 137.8125,
        se500s   => 140.625,
        se750s   => 143.4375,
        sexs     => 146.25,
        sexs250s => 149.0625,
        sse750e  => 149.0625,
        sexs500s => 151.875,
        sse500e  => 151.875,
        sexs750s => 154.6875,
        sse250e  => 154.6875,
        sse      => 157.5,
        sse250s  => 160.3125,
        sse500s  => 163.125,
        sxe500e  => 163.125,
        sse750s  => 165.9375,
        sxe      => 168.75,
        s750e    => 171.5625,
        s500e    => 174.375,
        s250e    => 177.1875,
        s        => 180,
        s250w    => 182.8125,
        s500w    => 185.625,
        s750w    => 188.4375,
        sxw      => 191.25,
        sxw250w  => 194.0625,
        sxw500w  => 196.875,
        ssw500s  => 196.875,
        sxw750w  => 199.6875,
        ssw      => 202.5,
        ssw250w  => 205.3125,
        swxs750s => 205.3125,
        ssw500w  => 208.125,
        swxs500s => 208.125,
        ssw750w  => 210.9375,
        swxs250s => 210.9375,
        swxs     => 213.75,
        sw750s   => 216.5625,
        sw500s   => 219.375,
        sw250s   => 222.1875,
        sw       => 225,
        sw250w   => 227.8125,
        sw500w   => 230.625,
        sw750w   => 233.4375,
        swxw     => 236.25,
        swxw250w => 239.0625,
        swxw500w => 241.875,
        swxw750w => 244.6875,
        wsw      => 247.50,
        wsw250w  => 250.3125,
        wsw500w  => 253.125,
        wsw750w  => 255.9372,
        wxs      => 258.75,
        w750s    => 261.5625,
        w500s    => 264.375,
        w250s    => 267.1875,
        w        => 270,
        w250n    => 272.8125,
        w500n    => 275.625,
        w750n    => 278.4375,
        wxn      => 281.25,
        wxn250n  => 284.0625,
        wxn500n  => 286.875,
        wxn750n  => 289.6875,
        wnw      => 292.5,
        wnw250n  => 295.3125,
        wnw500n  => 298.125,
        nwxw500w => 298.125,
        wnw750n  => 300.9375,
        nwxw     => 303.75,
        nw750w   => 306.5625,
        nw500w   => 309.375,
        nw250w   => 312.1875,
        nw       => 315,
        nw250n   => 317.8125,
        nw500n   => 320.625,
        nw750n   => 323.4375,
        nwxn     => 326.25,
        nwxn250n => 329.0625,
        nnw750w  => 329.0625,
        nwxn500n => 331.875,
        nnw500w  => 331.875,
        nwxn750n => 334.6875,
        nnw250w  => 334.6875,
        nnw      => 337.5,
        nxw750w  => 340.3125,
        nxw500w  => 343.125,
        nxw250w  => 345.9375,
        nxw      => 348.75,
        n750w    => 351.5625,
        n500w    => 354.375,
        n250w    => 357.1875,
    );
    if ( defined( $Directions{$ws} ) ) { return $Directions{$ws}; }
    return;    # Return undef if direction unrecognised
}

#--------------------------------------------------------------------
# How do we encode a direction like 'NNE through NxW'? This function
# averages two directions - dealing correctly with the 
# discontinuty at North.
sub direction_average {
    my ( $D1, $D2 ) = @_; # Two directions both in degrees
    unless ( defined($D1)
        && defined($D2)
        && $D1 >= 0
        && $D1 <= 360
        && $D2 >= 0
        && $D2 <= 360 )
    {
        return;
    }
    my $Diff = $D2 - $D1;
    if ( $Diff > 180 )  { $Diff = 360 - $Diff; }
    if ( $Diff < -180 ) { $Diff = 360 + $Diff; }
    my $Avg = $D1 + $Diff / 2;
    if ( $Avg > 360 ) { $Avg -= 360; }
    if ( $Avg < 0 ) { $Avg += 360; }
    return $Avg;
}
