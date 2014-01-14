# Data for IMMA attachment 99 - Supplemental
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

package MarineOb::IMMA;
use warnings;
use strict;
use Carp;

$ MarineOb::IMMA::attachments[99] = 'supplemental';

# List of parameters in icoads section
# In the order they are in on disc
@{ $MarineOb::IMMA::parameters[99] } = qw(ATTE SUPD);

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
%{ $MarineOb::IMMA::definitions[99] } = (
    ATTE => [ 1,     undef, undef, undef, undef, undef, 1 ],
    SUPD => [ undef, undef, undef, undef, undef, undef, 3 ]
);

