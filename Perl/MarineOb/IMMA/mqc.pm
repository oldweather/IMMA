# Data for IMMA attachment 3 - Model Quality Control
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

package MarineOb::IMMA;
use warnings;
use strict;
use Carp;

$MarineOb::IMMA::attachments[3] = 'mqc';

# List of parameters in icoads section
# In the order they are in on disc
@{ $MarineOb::IMMA::parameters[3] } = qw(CCCC BUID BMP BSWU SWU BSWV
  SWV BSAT BSRH SRH SIX BSST MST MSH BY BM BD BH BFL);

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
%{ $MarineOb::IMMA::definitions[3] } = (
    CCCC => [ 4, 65.,   90.,    undef, undef, undef, 3 ],
    BUID => [ 6, 48.,   57.,    65.,   90.,   undef, 3 ],
    BMP  => [ 5, 870.0, 1074.6, undef, undef, 0.1,   1 ],
    BSWU => [ 4, -99.9, 99.9,   undef, undef, 0.1,   1 ],
    SWU  => [ 4, -99.9, 99.9,   undef, undef, 0.1,   1 ],
    BSWV => [ 4, -99.9, 99.9,   undef, undef, 0.1,   1 ],
    SWV  => [ 4, -99.9, 99.9,   undef, undef, 0.1,   1 ],
    BSAT => [ 4, -99.9, 99.9,   undef, undef, 0.1,   1 ],
    BSRH => [ 3, 0.,    100.,   undef, undef, 1.,    1 ],
    SRH  => [ 3, 0.,    100.,   undef, undef, 1.,    1 ],
    SIX  => [ 1, 2.,    3.,     undef, undef, 1.,    1 ],
    BSST => [ 4, -99.9, 99.9,   undef, undef, 0.1,   1 ],
    MST  => [ 1, 0.,    9.,     undef, undef, 1.,    1 ],
    MSH  => [ 3, 0.,    999.,   undef, undef, 1.,    1 ],
    BY   => [ 4, 0.,    9999.,  undef, undef, 1.,    1 ],
    BM   => [ 2, 1.,    12.,    undef, undef, 1.,    1 ],
    BD   => [ 2, 1.,    31.,    undef, undef, 1.,    1 ],
    BH   => [ 2, 0.,    23.,    undef, undef, 1.,    1 ],
    BFL  => [ 2, 0.,    99.,    undef, undef, 1.,    1 ]
);

