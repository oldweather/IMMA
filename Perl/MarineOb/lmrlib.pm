# Perl translation of Scott and Sandy's lmrlib Fortran library
#  See http://icoads.noaa.gov/software/lmrlib
#
# This is a straight translation of the Fortran - I've preserved the
#  comments from the original. 
# Functionally identical to the Fortran version.
#

package MarineOb::lmrlib;

use strict;
use warnings;
use Carp;

@MarineOb::lmrlib::ISA       = ('Exporter');
@MarineOb::lmrlib::EXPORT_OK = qw(
  fxmmmb fxmbmm fxeimb fxmbei fxfimb fxmbfi
  fwbptf fwbptc fwbptg fwbpgv ixt0ok ixt1ok
  fxtftc fxtctf fxtktc fxtctk fxtrtc fxtctr
  fxuvdd fxuvvv rxdvuv fxktms fxmskt fxk0ms
  fxmsk0 fxk1ms fxmsk1 ixbfkt fxbfms ix32dd
  ixdcdd rxltut ixdtnd rxnddt
);

my $PI = 3.14159265358979323846264338327950288;

#---------------------------------------------------------------------
# Convert barometric pressure in (standard) millimeters of mercury (mm)
#  to millibars (hPa), e.g., fxmmmb(760.) = 1013.25 (one atmosphere)
#  (List, 1966, p. 13).
#     List, R.J., 1966: Smithsonian Meteorological Tables.
#           Smithsonian Institution, Washington, DC, 527 pp.
#     WMO (World Meteorological Organization), 1966: International
#           Meteorological Tables, WMO-No.188.TP.94.
sub fxmmmb {
    my $mm = shift;    # pressure in mm

    # factor from List (1966), p. 13 and Table 11; also in WMO (1966).
    return $mm * 1.333224;
}

#----------------------------------------------------------------------
# Convert barometric pressure in millibars (hPa; mb) to (standard)
#  millimeters of mercury.  Numerical inverse of {fxmmmb} (see for
#  background).  Note: This method yields better numerical agreement
#  in cross-testing against that routine than the factor 0.750062.
sub fxmbmm {
    my $mb = shift;    # Pressure in mb
    return $mb / 1.333224;
}

#-----------------------------------------------------------------------
# Convert barometric pressure in (standard) inches (English) of
# mercury (in) to millibars (hPa), e.g., fxeimb(29.9213) = 1013.25
#  (one atmosphere) (List, 1966, p. 13).
#  References:
#  List, R.J., 1966: Smithsonian Meteorological Tables.
#      Smithsonian Institution, Washington, DC, 527 pp.
#  WMO (World Meteorological Organization), 1966: International
#      Meteorological Tables, WMO-No.188.TP.94.
sub fxeimb {
    my $ei = shift;    # Pressure in English inches

    # factor from List (1966), Table 9.  Note: a slightly different factor
    #  33.8639 appears also on p. 13 of List (1966), and in WMO (1966).  Tests
    #  (32-bit Sun f77) over a wide range of pressure values (25.69"-31.73",
    #  approximately equivalent to ~870-1074.6 mb) indicated that the choice
    #  of constant made no numeric difference when data were converted to mb
    #  and then rounded to tenths, except for two cases of 0.1 mb difference
    #  (25.79" = 873.3/.4 mb; and 26.23" = 888.2/.3 mb).  If 1 mm = 1.333224
    #  mb and 1" = 25.4 mm, then 25.4mm = 33.86389 to 7 significant digits.
    return $ei * 33.86389;
}

#-----------------------------------------------------------------------
# Convert barometric pressure in millibars (hPa; mb) to (standard)
# inches (English) of mercury.  Numerical inverse of {fxeimb} (see for
#  background).  Note: This method yields better numerical agreement
#  in cross-testing against that routine than the factor 0.0295300.
sub fxmbei {
    my $mb;    # Pressure in mb
    return $mb / 33.86389;
}

#-----------------------------------------------------------------------
# Convert barometric pressure in inches (French) of mercury (fi) to
#  millibars (hPa).  Paris, instead of French, inches are referred
#  to in Lamb (1986), but these appear to be equivalent units.  Note:
#  data in lines (twelve lines per inch) or in inches and lines need
#  to be converted to inches (plus any decimal fraction).
#  References:
#  IMC (International Meteorological Committee), 1890: International
#       Meteorological Tables, published in Conformity with a Resolution
#        of the Congress of Rome, 1879.  Gauthier-Villars et Fils, Paris.
#  Lamb, H.H., 1986: Ancient units used by the pioneers of meteorological
#       instruments.  Weather, 41, 230-233.
sub fxfimb {
    my $fi = shift;
    Pressure in French inches

      # factor for conversion of French inches to mm (IMC, 1890, p. B.2);
      # mm are then converted to mb via {fxmmmb}
      return fxmmmb( $fi * 27.069953 );
}

#------------------------------------------------------------------------
# Convert barometric pressure in millibars (hPa; mb) to inches (French)
#  of mercury.  Numerical inverse of {fxfimb} (see for background).
sub fxmbfi {
    my $mb = shift;    # Pressure in mb
    return fxmbmm($mb) / 27.069953;
}

#------------------------------------------------------------------------
# Correction value of barometric pressure (in mm or mb; standard
#  temperature of scale 0C) (bp) for temperature in Celsius (tc)
#  (see {fwbpgt} for additional background).
#  Reference:
#  List, R.J., 1966: Smithsonian Meteorological Tables.
#       Smithsonian Institution, Washington, DC, 527 pp.
sub fwbptc {
    my ( $bp, $tc ) = @_;    # Pressure in mb, Temperature in C

    # constants m and l from List (1966), p. 136.
    my $m = 0.0001818;
    my $l = 0.0000184;
    return -$bp * ( ( ( $m - $l ) * $tc ) / ( 1. + ( $m * $tc ) ) );
}

#------------------------------------------------------------------------
# Correction value of barometric pressure (in inches; standard
#  temperature of scale 62F) (bp) for temperature in Fahrenheit (tf)
#  (see {fwbpgt} for additional background).
#  Reference:
#  List, R.J., 1966: Smithsonian Meteorological Tables.
#        Smithsonian Institution, Washington, DC, 527 pp.
sub fwbptf {
    my ( $bp, $tf ) = @_;    # Pressure in inches, Temperature in Fahrenheit

    # constants m and l from List (1966), p. 137.
    my $m = 0.000101;
    my $l = 0.0000102;
    return -$bp *
      ( ( ( $m * ( $tf - 32. ) ) - ( $l * ( $tf - 62. ) ) ) /
          ( 1. + $m * ( $tf - 32. ) ) );
}

#------------------------------------------------------------------------
# Correction value (generalized) of barometric pressure (bp) for
#  temperature (t), depending on units [$u]:
#                                      standard temperature:
#      u  bp          t           of scale (ts)  of mercury (th)
#      -  ----------  ----------  -------------  -------------------
#      1  mm or mb    Celsius      0C             0C
#      2  Eng. in.    Fahrenheit  62F (16.667C)  32F (0C) (pre-1955)
#      3  Eng. in.    Fahrenheit  32F (0C)       32F (0C) (1955-)
#      4  French in.  Reaumur     13R (16.25C)    0R (0C)
# The returned {fwbptg} value is in the same units as, and is to be
# added to, bp.  Establishment of 0C/32F as the standard temperature
# for both scale and mercury as implemented under u=1 and 3 became
# effective 1 Jan 1955 under WMO International Barometer Conventions
# (WBAN, 12 App.1.4.1--2; see also WMO, 1966 and UKMO, 1969).  List
# (1966), p. 139 states that "the freezing point of water is universally
# adopted as the standard temperature of the mercury, to which all
# readings are to be reduced," but for English units uses only 62F for
# the standard temperature of the scale.  Note: Results under u=4, and
# the utilized settings of constants l and m, have not been verified
# against published values, if available.  IMC (1890, p. B.24) states
# that in "old Russian barometer readings expressed in English half lines
# (0.05 in) the mercury and the scale were set to the same temperature
# 62F."  UKMO (1969, p. 5) states that for Met. Office barometers prior
# to 1955 reading in millibars the standard temperature was 285K (12C).
# This routine does not handle these, or likely other historical cases.
# References:
# IMC (International Meteorological Committee), 1890: International
#       Meteorological Tables, published in Conformity with a Resolution
#       of the Congress of Rome, 1879.  Gauthier-Villars et Fils, Paris.
# List, R.J., 1966: Smithsonian Meteorological Tables.
#       Smithsonian Institution, Washington, DC, 527 pp.
# UKMO (UK Met. Office), 1969: Marine Observer's Handbook (9th ed.).
#       HMSO, London, 152 pp.
# US Weather Bureau, Air Weather Service, and Naval Weather Service,
#       1963: Federal Meteorological Handbook No. 8--Manual of Barometry
#       (WBAN), Volume 1 (1st ed.).  US GPO, Washington, DC.
# WMO (World Meteorological Organization), 1966: International
#       Meteorological Tables, WMO-No.188.TP.94.
sub fwbptg {
    my ( $bp, $t, $u ) = @_;    # Pressure, temperature, and units flag

    # constants ts and th are from List (1966), pp. 136-137 (u=1-2); WBAN
    # 12 App.1.4.1--3 (u=3); and IMC (1890), p. B.24 (u=4).
    my @ts = ( 0.0, 62., 32., 13. );
    my @th = ( 0.0, 32., 32., 0.0 );

    # constants m and l are from List (1966), pp. 136-137 (u=1-3) and WBAN,
    # pp. 5-4 and 5-5 (for metric and English units).  For u=4, the u=1
    # constants were multiplied by 5/4 (after List, 1966, p. 137).
    my @m = ( 0.0001818, 0.000101,  0.000101,  0.000227 );
    my @l = ( 0.0000184, 0.0000102, 0.0000102, 0.0000230 );

    # test u for valid range
    if ( $u < .1 || $u > 4 ) {
        croak "fwbptg error. invalid u=$u";
    }
    return -$bp *
      ( ( ( $m[$u-1] * ( $t - $th[$u-1] ) ) - ( $l[$u-1] * ( $t - $ts[$u-1] ) ) ) /
          ( 1. + ( $m[$u-1] * ( $t - $th[$u-1] ) ) ) );
}

#-------------------------------------------------------------------------
# Correction value of barometric pressure (bp) for gravity depending on
#  latitude (rlat), with constants set depending on gmode (for COADS, we
#  adopt gmode=1 for 1955-forward, and gmode=2 for data prior to 1955):
#        g1 (equation 1)   g2 (equation 2)   Comment
#        ---------------   ---------------   -----------------------------
#  1 =          g45               g0         yields List (1966), Table 47B
#  2 =          g0                g0         follows GRAVCOR (pre-1955)
#  3 =          g45               g45        (of unknown utility)
#  The returned {fwbpgv} value is in the same units as, and is to be added
#  to, bp (units for bp are unspecified; Table 47B has columns for inches,
#  millimeters, and millibars).  Usage of g0 and g45 as implemented under
#  gmode=1 became effective 1 Jan 1955 under WMO International Barometer
#  Conventions: g45 is a "best" estimate of acceleration of gravity at 45
#  deg latitude and sea level, and g0 is the value of standard (normal)
#  gravity "to which reported barometric data in mm or inches of mercury
#  shall refer, but it does not represent the value of gravity at latitude
#  45 deg, at sea level" (WBAN, 12 App.1.4.1--2; see also List, 1966, pp.
#  3-4, and WMO, 1966).  For example, UK Met. Office MK I (MK II) barometers
#  issued before (starting) 1 January 1955 were graduated to read correctly
#  when the value of gravity was g45 (g0) (UKMO, 1969).  As shown by test
#  routines {tpbpg1,tpbpg2}, gmode=2 and 3 yield virtually the same results.
#  References:
#  List, R.J., 1966: Smithsonian Meteorological Tables.
#        Smithsonian Institution, Washington, DC, 527 pp.
#  UKMO (UK Met. Office), 1969: Marine Observer's Handbook (9th ed.).
#        HMSO, London, 152 pp.
#  US Weather Bureau, Air Weather Service, and Naval Weather Service,
#        1963: Federal Meteorological Handbook No. 8--Manual of Barometry
#        (WBAN), Volume 1 (1st ed.).  US GPO, Washington, DC.
#  WMO (World Meteorological Organization), 1966: International
#        Meteorological Tables, WMO-No.188.TP.94.
#----------------------------------------------------------------------------
sub fwbpgv {
    my ( $bp, $rlat, $gmode ) = @_;

    # g45 from List (1966), p. 488 ("best" sea-level gravity at latitude 45)
    my $g45 = 980.616;

    # g0  from List (1966), p. 200 ("standard" acceleration of gravity)
    my $g0 = 980.665;

    # check latitude
    if ( $rlat < -90 || $rlat > 90 ) {
        croak "fwbpgv error. invalid rlat=$rlat";
    }

    # check gmode, and set g1 and g2
    my ( $g1, $g2 );
    if ( $gmode == 1 ) {
        $g1 = $g45;
        $g2 = $g0;
    }
    elsif ( $gmode == 2 ) {
        $g1 = $g0;
        $g2 = $g0;
    }
    elsif ( $gmode == 3 ) {
        $g1 = $g45;
        $g2 = $g45;
    }
    else {
        croak "fwbpgv error. invalid gmode=$gmode";
    }

    # convert degrees to radians
    my $rlatr = $rlat * ( $PI / 180 );

    # List (1966), p. 488, equation 1 (c is the local acceleration of gravity)
    my $a = 0.0000059 * ( cos( 2.0 * $rlatr )**2 );
    my $b = 1. - 0.0026373 * cos( 2.0 * $rlatr );
    my $c = $g1 * ( $a + $b );

    # List (1966), p. 202, equation 2
    return ( ( $c - $g2 ) / $g2 ) * $bp;
}

#--------------------------------------------------------------------------
# Convert "proportion of sky clear" in tenths (t0), to oktas (eighths
#  of sky covered; WMO code 2700).  The t0 code, specified in Maury
#  (1854), was documented for use, e.g., for US Marine Meteorological
#  Journals (1878-1893).  The dates of transition to instead reporting
#  "proportion of sky covered" (t1, as handled by {ixt1ok}) may have
#  varied nationally.  Following shows the mappings of t0/t1 to oktas
#  as provided by these routines ({tpt0t1} output):
#  10ths clear (t0)   oktas   10ths cover (t1)   oktas
#  ----------------   -----   ----------------   -----
#                10       0                  0       0
#                 9       1                  1       1
#                 8       2                  2       2
#                 7       2                  3       2
#                 6       3                  4       3
#                 5       4                  5       4
#                 4       5                  6       5
#                 3       6                  7       6
#                 2       6                  8       6
#                 1       7                  9       7
#                 0       8                 10       8
#  Reference:
#  Maury, M.F., 1854: Maritime Conference held at Brussels for devising
#        a uniform system of meteorological observations at sea, August
#        and September, 1853.  Explanations and Sailing Directions to
#        Accompany the Wind and Current Charts, 6th Ed., Washington, DC,
#        pp. 54-88.
sub ixt0ok {
    my $t0 = shift;    # tenths of sky clear

    # check validity of t0
    if ( $t0 < 0 || $t0 > 10 ) {
        croak "ixt0ok error. illegal t0=$t0";
    }

    # convert tenths of "sky clear" (t0) to tenths of "sky covered" (t1)
    #  (Note: assumption: no known basis in documentation)
    my $t1 = 10 - $t0;

    # convert tenths of "sky covered" to oktas
    return ixt1ok($t1);
}

#------------------------------------------------------------------------
# Convert tenths (of sky covered) (t1), to oktas (eighths of sky
#  covered; WMO code 2700).  This implements the mapping of tenths
#  to oktas shown below (left-hand columns) from NCDC (1968), section
#  4.5, scale 7.  In contrast, the right-hand columns show a reverse
#  mapping of "code no." (referring to oktas in the synoptic code)
#  back to tenths from Riehl (1947) (the justifications for the two
#  approaches are not known):
#        oktas  <-  tenths     |    code no.  ->  tenths
#        -----      -------    |    --------      -------
#          0         0         |        0           0
#          1         1         |        1           0
#          2         2 or 3    |        2           1
#          3         4         |        3           2.5
#          4         5         |        4           5
#          5         6         |        5           7.5
#          6         7 or 8    |        6           9
#          7         9         |        7          10
#          8        10         |        8          10
#          9        obscured
#  Input t1 values must be limited to 0-10; "obscured" is not handled.
#  References:
#  NCDC (National Climatic Data Center), 1968: TDF-11 Reference Manual.
#        NCDC, Asheville, NC.
#  Riehl, 1947: Diurnal variation of cloudiness over the subtropical
#        Atlantic Ocean.  Bull. Amer. Meteor. Soc., 28, 37-40.
sub ixt1ok {
    my $t1=shift;    # tenths of sky covered
    my @ok = ( 0, 1, 2, 2, 3, 4, 5, 6, 6, 7, 8 );

    # check validity of t1
    if ( $t1 < 0 || $t1 > 10 ) {
        croak "ixt1ok error. illegal t1=$t1";
    }

    # convert from tenths to oktas
    return $ok[$t1];
}

#------------------------------------------------------------------------
# Convert temperature in degrees Fahrenheit (tc) to degrees Celsius.
#   Reference:
#   List, R.J., 1966: Smithsonian Meteorological Tables.
#         Smithsonian Institution, Washington, DC, 527 pp.
sub fxtftc {
    my $tf = shift;    # Temperature in Farenheit

    # equation from List (1966), Table 2 (p. 17).
    return ( 5.0 / 9.0 ) * ( $tf - 32.0 );
}

#------------------------------------------------------------------------
# Convert temperature in degrees Celsius (tc) to degrees Fahrenheit.
#   Reference:
#   List, R.J., 1966: Smithsonian Meteorological Tables.
#         Smithsonian Institution, Washington, DC, 527 pp.
sub fxtctf {
    my $tc = shift;    # Temperature in Celsius

    # equation from List (1966), Table 2 (p. 17).
    return ( ( 9.0 / 5.0 ) * $tc ) + 32.0;
}

#------------------------------------------------------------------------
# Convert temperature in Kelvins (tk) to degrees Celsius.
sub fxtktc {
    my $tk = shift;    # Temperature in Kelvin
    if ( $tk < 0.0 ) {
        croak "fxtktc error. negative input tk=$tk";
    }
    return $tk - 273.15;
}

#-------------------------------------------------------------------------
# Convert temperature in degrees Celsius (tc) to Kelvins.
sub fxtctk {
    my $tc     = shift;          # Temperature in Celsius
    my $fxtctk = $tc + 273.15;
    if ( $fxtctk < 0.0 ) {
        croak "fxtctk error. negative output=$fxtctk";
    }
    return $fxtctk;
}

#----------------------------------------------------------------------
# Convert temperature in degrees Reaumur (tc) to degrees Celsius.
#  Reference:
#  List, R.J., 1966: Smithsonian Meteorological Tables.
#        Smithsonian Institution, Washington, DC, 527 pp.
sub fxtrtc {
    my $tr = shift;    # Temperature in Reaumur

    # equation from List (1966), Table 2 (p. 17).
    return ( 5.0 / 4.0 ) * $tr;
}

#----------------------------------------------------------------------
# Convert temperature in degrees Celsius (tc) to degrees Reaumur.
#  Reference:
#  List, R.J., 1966: Smithsonian Meteorological Tables.
#         Smithsonian Institution, Washington, DC, 527 pp.
sub fxtctr {
    my $tc = shift;

    # equation from List (1966), Table 2 (p. 17).
    return ( 4.0 / 5.0 ) * $tc;
}

#-----------------------------------------------------------------------
# Convert wind vector eastward and northward components (u,v) to
#  direction (from) in degrees (clockwise from 0 degrees North).
sub fxuvdd {
    my ( $u, $v ) = @_;
    my $a;
    if ( $u == 0 && $v == 0 ) {
        $a = 0.0;
    }
    else {
        $a = atan2( $v, $u ) * ( 180.0 / $PI );
    }
    my $fxuvdd = 270.0 - $a;
    if ( $fxuvdd >= 360 ) { $fxuvdd = $fxuvdd - 360.0; }
    return $fxuvdd;
}

#-----------------------------------------------------------------------
# Convert wind vector eastward and northward components (u,v) to
#   velocity.
sub fxuvvv {
    my ( $u, $v ) = @_;    # U and V components (any units - must be the same)
    return sqrt( $u**2 + $v**2 );
}

#-------------------------------------------------------------------------
# Convert wind direction (dd; clockwise from 0 degrees North) and
#  velocity (vv) to vector eastward and northward components (u,v).
sub rxdvuv {
    my ( $dd, $vv ) = @_;
    my $ang = $dd * ( $PI / 180.0 );
    my $u   = -$vv * sin($ang);
    my $v   = -$vv * cos($ang);
    return ( $u, $v );
}

#-------------------------------------------------------------------------
# Convert from knots (kt; with respect to the international nautical
#  mile) to meters per second (see {tpktms} for details).
sub fxktms {
    my $kt = shift;    # Value in knots
    return $kt * 0.51444444444444444444;
}

#--------------------------------------------------------------------------
# Convert from meters per second (ms) to knots (with respect to the
#   international nautical mile) (see {tpktms} for details).
sub fxmskt {
    my $ms = shift;    # Value in meters per second
    return $ms * 1.9438444924406047516;
}

#--------------------------------------------------------------------------
# Convert from knots (k0; with respect to the U.S. nautical mile) to
#  meters per second (see {tpktms} for details).
sub fxk0ms {
    my $k0 = shift;    # U.S. knots
    return $k0 * 0.51479111111111111111;
}

#--------------------------------------------------------------------------
# Convert from meters per second (ms) to knots (with respect to the
#  U.S. nautical mile) (see {tpktms} for details).
sub fxmsk0 {
    my $ms = shift;    # value in meters per second
    return $ms * 1.9425354836481679732;
}

#--------------------------------------------------------------------------
# Convert from knots (k1; with respect to the Admiralty nautical mile)
#   to meters per second (see {tpktms} for details).
sub fxk1ms {
    my $k1 = shift;    # Admiralty knots
    return $k1 * 0.51477333333333333333;
}

#--------------------------------------------------------------------------
# Convert from meters per second (ms) to knots (with respect to the
#  Admiralty nautical mile) (see {tpktms} for details).
sub fxmsk1 {
    my $ms = shift;    # meters per second
    return $ms * 1.9426025694156651471;
}

#--------------------------------------------------------------------------
# Convert from Beaufort force 0-12 (bf) to "old" (WMO code 1100)
#  midpoint in knots.  From NCDC (1968), conversion scale 5 (sec.
#  4.4).  Note: Midpoint value 18 looks questionable, but appeared
#  originally in UKMO (1948).
#  References:
#  NCDC (National Climatic Data Center), 1968: TDF-11 Reference Manual.
#        NCDC, Asheville, NC.
#  UKMO (UK Met. Office), 1948: International Meteorological Code
#        Adopted by the International Meteorological Organisation,
#        Washington, 1947 (Decode for the Use of Shipping, effective
#        from 1st January, 1949).  Air Ministry, Meteorological Office,
#        HM Stationary Office, London, 39 pp.
sub ixbfkt {
    my $bf = shift;                                             # Beaufort force
    my @kt = ( 0, 2, 5, 9, 13, 18, 24, 30, 37, 44, 52, 60, 68 );
    if ( $bf < 0 || $bf > 12 ) {
        croak "ixbfkt error.  bf=$bf";
    }
    return $kt[$bf];
}

#-------------------------------------------------------------------------
# Convert from Beaufort force 0-12 (bf) to "old" (WMO code 1100)
#   midpoint in meters per second.  From Slutz et al. (1985) supp.
#   K, Table K5-5 (p. K29).  See {ixbfkt} for additional background.
#   Reference:
#   Slutz, R.J., S.J. Lubker, J.D. Hiscox, S.D. Woodruff, R.L. Jenne,
#       D.H. Joseph, P.M. Steurer, and J.D. Elms, 1985: Comprehensive
#        Ocean-Atmosphere Data Data Set; Release 1.  NOAA
#        Environmental Research Laboratories, Climate Research
#        Program, Boulder, Colo., 268 pp. (NTIS PB86-105723).
sub fxbfms {
    my $bf = shift;    # Beaufort force
    my @ms =
      ( 0., 1., 2.6, 4.6, 6.7, 9.3, 12.3, 15.4, 19., 22.6, 26.8, 30.9, 35. );
    if ( $bf < 0 || $bf > 12 ) {
        croak "fxbfms error.  bf=$bf";
    }
    return $ms[$bf];
}

#-------------------------------------------------------------------------
# Convert 4-character 32-point wind direction abbreviation c32 into
#  degrees and numeric code 1-32.  Recognized
#  abbreviations are in cwd, with these characteristics: left-justified,
#  upper-case, with trailing blank fill, and where "X" stands for "by".
sub ix32dd {
    my $c32 = uc(shift);    # 4-character wind direction string
    my %cwd = (
        'NXE ' => 1,
        'NNE ' => 2,
        'NEXN' => 3,
        'NE  ' => 4,
        'NEXE' => 5,
        'ENE ' => 6,
        'EXN ' => 7,
        'E   ' => 8,
        'EXS ' => 9,
        'ESE ' => 10,
        'SEXE' => 11,
        'SE  ' => 12,
        'SEXS' => 13,
        'SSE ' => 14,
        'SXE ' => 15,
        'S   ' => 16,
        'SXW ' => 17,
        'SSW ' => 18,
        'SWXS' => 19,
        'SW  ' => 20,
        'SWXW' => 21,
        'WSW ' => 22,
        'WXS ' => 23,
        'W   ' => 24,
        'WXN ' => 25,
        'WNW ' => 26,
        'NWXW' => 27,
        'NW  ' => 28,
        'NWXN' => 29,
        'NNW ' => 30,
        'NXW ' => 31,
        'N   ' => 32
    );
    if ( defined( $cwd{$c32} ) ) {
        return ( ixdcdd( $cwd{$c32} ), $cwd{$c32} );
    }
    else {
        return ( undef, undef );
    }
}

#-------------------------------------------------------------------------
# Convert 32-point wind direction numeric code dc into degrees.
#   Release 1, Table F2-1 defines the mapping of code dc to degrees in dwd.
sub ixdcdd {
    my $dc  = shift;    # Integer wind code 1-32;
    my @dwd = (
        11,  23,  34,  45,  56,  68,  79,  90,  101, 113, 124, 135,
        146, 158, 169, 180, 191, 203, 214, 225, 236, 248, 259, 270,
        281, 293, 304, 315, 326, 338, 349, 360
    );
    if   ( $dc >= 1 && $dc <= 32 ) { return $dwd[ $dc - 1 ]; }
    else                           { return; }
}

#--------------------------------------------------------------------------
# Convert local standard hour (ihr; in hundredths 0-2399) and "Julian"
#  day (i.e., any incrementable integer date) (idy) into coordinated
#  universal time (UTC) hour (uhr) and day (udy; decremented if the
#  dateline is crossed), using longitude (elon; in hundredths of degrees
#  0-35999, measured east of Greenwich).  Notes: a) Strict time zones,
#  including the International Date Line, are not employed.  b) In all
#  cases the western (eastern) boundary of each time zone is inclusive
#  (exclusive), i.e., 7.50W-7.49E, 7.50E-22.49E, ..., 172.50E-172.51W.
sub rxltut {
    my ( $ihr, $idy, $elon ) = @_;
    if ( $ihr < 0 || $ihr > 2399 ) {
        croak "error rxltut. ihr=$ihr";
    }
    elsif ( $elon < 0 || $elon > 35999 ) {
        croak "error rxltut. elon=$elon";
    }
    my $wlon = 36000 - $elon;
    my $udy  = $idy;
    my $dhr  = int(( $wlon + 749 ) / 1500);
    my $uhr  = $ihr + $dhr * 100;
    if ( $uhr >= 2400 ) {
        $udy = $udy + 1;
        $uhr = $uhr - 2400;
    }
    if ( $wlon >= 18000 ) { $udy = $udy - 1 }
    return ( $uhr, $udy );
}

#------------------------------------------------------------------
# Test wheater a year is a leap year
sub leap {
    my $year = shift;
    if ( ( $year % 4 == 0 && $year % 100 != 0 ) || $year % 400 == 0 ) {
        return 1;
    }
    return;
}

#-------------------------------------------------------------------
# Convert from date (iday,imonth,iyear) to number of days since
#  1 Jan 1770.
sub ixdtnd {
    my ( $iday, $imonth, $iyear ) = @_;
    my @days = ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );
    if (
           $iyear < 1770
        || $imonth < 1
        || $imonth > 12
        || $iday < 1
        || ( $iday > $days[ $imonth - 1 ]
            && ( $imonth != 2 || !leap($iyear) || $iday != 29 ) )
      )
    {
        return;
    }
    my $ndays = 0;
    for ( my $year = 1770 ; $year < $iyear ; $year++ ) {
        $ndays = $ndays + 365;
        if ( leap($year) ) { $ndays += 1; }
    }
    for ( my $month = 1 ; $month < $imonth ; $month++ ) {
        $ndays += $days[ $month - 1 ];
        if ( $month == 2 && leap($iyear) ) { $ndays += 1; }
    }
    $ndays += $iday - 1;
    return $ndays;
}

#------------------------------------------------------------------
# Convert from number of days (ndays) since 1 Jan 1770 to
#  date (iday,imonth,iyear).
sub rxnddt {
    my $ndays = shift;
    my @days = ( 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 );
    if ( $ndays < 0 ) { return ( undef, undef, undef ); }
    my $mdays = $ndays;
    my $iyear = 1770;
    my $n     = 365;
    while ( ( $mdays - $n ) >= 0 ) {
        $mdays -= $n;
        $iyear += 1;
        $n = 365;
        if ( leap($iyear) ) { $n += 1; }
    }
    my $imonth = 1;
    $n = $days[$imonth-1];
    while ( ( $mdays - $n ) >= 0 ) {
        $mdays -= $n;
        $imonth += 1;
        $n = $days[$imonth-1];
        if ( $imonth == 2 && leap($iyear) ) { $n += 1; }
    }
    my $iday = $mdays + 1;
    return ( $iday, $imonth, $iyear );
}
