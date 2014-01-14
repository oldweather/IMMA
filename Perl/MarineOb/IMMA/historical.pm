# Data for IMMA attachment 5 - Historical
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

package MarineOb::IMMA;
use warnings;
use strict;
use Carp;

$MarineOb::IMMA::attachments[5] = 'historical';

# List of parameters in icoads section
# In the order they are in on disc
@{ $MarineOb::IMMA::parameters[5] } =
  qw(WFI WF XWI XW XDI XD SLPI TAI TA XNI XN);

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
%{ $MarineOb::IMMA::definitions[5] } = (
    WFI  => [ 1, undef, undef, undef, undef, undef, 1 ],
    WF   => [ 2, undef, undef, undef, undef, undef, 1 ],
    XWI  => [ 1, undef, undef, undef, undef, undef, 1 ],
    XW   => [ 3, undef, undef, undef, undef, 0.1,   1 ],
    XDI  => [ 1, undef, undef, undef, undef, undef, 1 ],
    XD   => [ 2, undef, undef, undef, undef, undef, 1 ],
    SLPI => [ 1, undef, undef, undef, undef, undef, 1 ],
    TAI  => [ 1, undef, undef, undef, undef, undef, 1 ],
    TA   => [ 4, undef, undef, undef, undef, undef, 1 ],
    XNI  => [ 1, undef, undef, undef, undef, undef, 1 ],
    XN   => [ 2, undef, undef, undef, undef, undef, 1 ]
);

