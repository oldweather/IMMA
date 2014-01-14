# Data for IMMA attachment 4 - Ship metadata
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

package MarineOb::IMMA;
use warnings;
use strict;
use Carp;

$MarineOb::IMMA::attachments[4] = 'metadata';

# List of parameters in icoads section
# In the order they are in on disc
@{ $MarineOb::IMMA::parameters[4] } = qw(C1M OPM KOV COR TOB TOT
  EOT LOT TOH EOH SIM LOV DOS HOP HOT HOB HOA SMF SME SMV);

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
%{ $MarineOb::IMMA::definitions[4] } = (
    C1M => [ 2, 65., 90.,    undef, undef, undef, 3 ],
    OPM => [ 2, 0.,  99.,    undef, undef, 1.,    1 ],
    KOV => [ 2, 32., 126.,   undef, undef, undef, 3 ],
    COR => [ 2, 65., 90.,    undef, undef, undef, 3 ],
    TOB => [ 3, 32., 126.,   undef, undef, undef, 3 ],
    TOT => [ 3, 32., 126.,   undef, undef, undef, 3 ],
    EOT => [ 2, 32., 126.,   undef, undef, undef, 3 ],
    LOT => [ 2, 32., 126.,   undef, undef, undef, 3 ],
    TOH => [ 1, 32., 126.,   undef, undef, undef, 3 ],
    EOH => [ 2, 32., 126.,   undef, undef, undef, 3 ],
    SIM => [ 3, 32., 126.,   undef, undef, undef, 3 ],
    LOV => [ 3, 0.,  999.,   undef, undef, 1.,    1 ],
    DOS => [ 2, 0.,  99.,    undef, undef, 1.,    1 ],
    HOP => [ 3, 0.,  999.,   undef, undef, 1.,    1 ],
    HOT => [ 3, 0.,  999.,   undef, undef, 1.,    1 ],
    HOB => [ 3, 0.,  999.,   undef, undef, 1.,    1 ],
    HOA => [ 3, 0.,  999.,   undef, undef, 1.,    1 ],
    SMF => [ 5, 0.,  99999., undef, undef, 1.,    1 ],
    SME => [ 5, 0.,  99999., undef, undef, 1.,    1 ],
    SMV => [ 2, 0.,  99.,    undef, undef, 1.,    1 ]
);

