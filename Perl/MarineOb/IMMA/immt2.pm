# Data for IMMA attachment 2 - IMM2-3/FM 13
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

package MarineOb::IMMA;
use warnings;
use strict;
use Carp;

$MarineOb::IMMA::attachments[2] = 'immt2';

# List of parameters in icoads section
# In the order they are in on disc
@{ $MarineOb::IMMA::parameters[2] } = qw(OS OP FM IX W2 SGN SGT SGH
  WMI SD2 SP2 SH2 IS ES RS IC1 IC2 IC3 IC4 IC5 IR RRR
  TR QCI QI1 QI2 QI3 QI4 QI5 QI6 QI7 QI8 QI9 QI10 QI11
  QI12 QI13 QI14 QI15 QI16 QI17 QI18 QI19 QI20 QI21 HDG
  COG SOG SLL SLHH RWD RWS);

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
%{ $MarineOb::IMMA::definitions[2] } = (
    OS   => [ 1, 0.,   6.,   undef, undef, 1.,  1 ],
    OP   => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    FM   => [ 2, 0.,   8.,   undef, undef, 1.,  1 ],
    IX   => [ 1, 1.,   7.,   undef, undef, 1.,  1 ],
    W2   => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    SGN  => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    SGT  => [ 1, 0.,   10.,  undef, undef, 1.,  2 ],
    SGH  => [ 2, 0.,   50.,  56.,   99.,   1.,  1 ],
    WMI  => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    SD2  => [ 2, 0.,   38.,  undef, undef, 1.,  1 ],
    SP2  => [ 2, 0.,   30.,  99.,   99.,   1.,  1 ],
    SH2  => [ 2, 0.,   99.,  undef, undef, 1.,  1 ],
    IS   => [ 1, 1.,   5.,   undef, undef, 1.,  1 ],
    ES   => [ 2, 0.,   99.,  undef, undef, 1.,  1 ],
    RS   => [ 1, 0.,   4.,   undef, undef, 1.,  1 ],
    IC1  => [ 1, 0.,   10.,  undef, undef, 1.,  2 ],
    IC2  => [ 1, 0.,   10.,  undef, undef, 1.,  2 ],
    IC3  => [ 1, 0.,   10.,  undef, undef, 1.,  2 ],
    IC4  => [ 1, 0.,   10.,  undef, undef, 1.,  2 ],
    IC5  => [ 1, 0.,   10.,  undef, undef, 1.,  2 ],
    IR   => [ 1, 0.,   4.,   undef, undef, 1.,  1 ],
    RRR  => [ 3, 0.,   999., undef, undef, 1.,  1 ],
    TR   => [ 1, 1.,   9.,   undef, undef, 1.,  1 ],
    QCI  => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI1  => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI2  => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI3  => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI4  => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI5  => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI6  => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI7  => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI8  => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI9  => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI10 => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI11 => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI12 => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI13 => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI14 => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI15 => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI16 => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI17 => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI18 => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI19 => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI20 => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    QI21 => [ 1, 0.,   9.,   undef, undef, 1.,  1 ],
    HDG  => [ 3, 0.,   360., undef, undef, 1.,  1 ],
    COG  => [ 3, 0.,   360., undef, undef, 1.,  1 ],
    SOG  => [ 2, 0.,   99.,  undef, undef, 1.,  1 ],
    SLL  => [ 2, 0.,   99.,  undef, undef, 1.,  1 ],
    SLHH => [ 3, -99., 99.,  undef, undef, 1.,  1 ],
    RWD  => [ 3, 1.,   362., undef, undef, 1.,  1 ],
    RWS  => [ 3, 0.0,  99.9, undef, undef, 0.1, 1 ]
);

