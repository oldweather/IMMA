# Data for IMMA attachment 1 - icoads
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

package MarineOb::IMMA;
use warnings;
use strict;
use Carp;

$MarineOb::IMMA::attachments[1] = 'icoads';

# List of parameters in icoads section
# In the order they are in on disc
@{ $MarineOb::IMMA::parameters[1] } = qw(BSI B10 B1 DCK SID PT DUPS DUPC TC PB
  WX SX C2
  SQZ SQA AQZ AQA UQZ UQA VQZ VQA PQZ PQA DQZ DQA
  ND SF AF UF VF PF RF
  ZNC WNC BNC XNC YNC PNC ANC GNC DNC SNC CNC ENC FNC TNC
  QCE LZ QCZ);

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
%{ $MarineOb::IMMA::definitions[1] } = (
    BSI  => [ 1, undef, undef, undef, undef, 1., 1 ],
    B10  => [ 3, 1.,    648.,  undef, undef, 1., 1 ],
    B1   => [ 2, 0.,    99.,   undef, undef, 1., 1 ],
    DCK  => [ 3, 0.,    999.,  undef, undef, 1., 1 ],
    SID  => [ 3, 0.,    999.,  undef, undef, 1., 1 ],
    PT   => [ 2, 0.,    15.,   undef, undef, 1., 1 ],
    DUPS => [ 2, 0.,    14.,   undef, undef, 1., 1 ],
    DUPC => [ 1, 0.,    2.,    undef, undef, 1., 1 ],
    TC   => [ 1, 0.,    1.,    undef, undef, 1., 1 ],
    PB   => [ 1, 0.,    2.,    undef, undef, 1., 1 ],
    WX   => [ 1, 1.,    1.,    undef, undef, 1., 1 ],
    SX   => [ 1, 1.,    1.,    undef, undef, 1., 1 ],
    C2   => [ 2, 0.,    40.,   undef, undef, 1., 1 ],
    SQZ  => [ 1, 1.,    35.,   undef, undef, 1., 2 ],
    SQA  => [ 1, 1.,    21.,   undef, undef, 1., 2 ],
    AQZ  => [ 1, 1.,    35.,   undef, undef, 1., 2 ],
    AQA  => [ 1, 1.,    21.,   undef, undef, 1., 2 ],
    UQZ  => [ 1, 1.,    35.,   undef, undef, 1., 2 ],
    UQA  => [ 1, 1.,    21.,   undef, undef, 1., 2 ],
    VQZ  => [ 1, 1.,    35.,   undef, undef, 1., 2 ],
    VQA  => [ 1, 1.,    21.,   undef, undef, 1., 2 ],
    PQZ  => [ 1, 1.,    35.,   undef, undef, 1., 2 ],
    PQA  => [ 1, 1.,    21.,   undef, undef, 1., 2 ],
    DQZ  => [ 1, 1.,    35.,   undef, undef, 1., 2 ],
    DQA  => [ 1, 1.,    21.,   undef, undef, 1., 2 ],
    ND   => [ 1, 1.,    2.,    undef, undef, 1., 1 ],
    SF   => [ 1, 1.,    15.,   undef, undef, 1., 2 ],
    AF   => [ 1, 1.,    15.,   undef, undef, 1., 2 ],
    UF   => [ 1, 1.,    15.,   undef, undef, 1., 2 ],
    VF   => [ 1, 1.,    15.,   undef, undef, 1., 2 ],
    PF   => [ 1, 1.,    15.,   undef, undef, 1., 2 ],
    RF   => [ 1, 1.,    15.,   undef, undef, 1., 2 ],
    ZNC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    WNC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    BNC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    XNC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    YNC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    PNC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    ANC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    GNC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    DNC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    SNC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    CNC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    ENC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    FNC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    TNC  => [ 1, 1.,    10.,   undef, undef, 1., 2 ],
    QCE  => [ 2, 0.,    63.,   undef, undef, 1., 1 ],
    LZ   => [ 1, 1.,    1.,    undef, undef, 1., 1 ],
    QCZ  => [ 2, 0.,    31.,   undef, undef, 1., 1 ]
);

