# Data for IMMA attachment 98 - Unique record ID
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

package MarineOb::IMMA;
use warnings;
use strict;
use Carp;

$MarineOb::IMMA::attachments[98] = 'uida';

# List of parameters in icoads section
# In the order they are in on disc
@{ $MarineOb::IMMA::parameters[98] } = qw(UID RN1 RN2 RN3 RSA IRF);

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
%{ $MarineOb::IMMA::definitions[98] } = (
    UID  => [ 6, undef, undef, undef, undef, undef, 3 ],
    RN1  => [ 1, 0.,    36.,   undef, undef,    1., 2 ],
    RN2  => [ 1, 0.,    36.,   undef, undef,    1., 2 ],
    RN3  => [ 1, 0.,    36.,   undef, undef,    1., 2 ],
    RSA  => [ 1, 0.,    2.,    undef, undef,    1., 1 ],
    IRF  => [ 1, 0.,    1.,    undef, undef,    1., 1 ]
);

