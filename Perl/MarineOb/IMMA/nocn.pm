# Data for IMMA attachment 8 - Near-Surface Oceanographic
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

package MarineOb::IMMA;
use warnings;
use strict;
use Carp;

$MarineOb::IMMA::attachments[8] = 'nocn';

# List of parameters in icoads section
# In the order they are in on disc
@{ $MarineOb::IMMA::parameters[8] } = qw(OTV OTZ OSV OSZ OOV OOZ OPV OPZ
                                         OSIV OSIZ ONV ONZ OPHV OPHZ OCV
                                         OCZ OAV OAZ OPCV OPCZ ODV ODZ PUID);

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
%{ $MarineOb::IMMA::definitions[8] } = (
    'OTV'  => [  5,  -3.,  38.999,    undef,    undef,  0.001,  1 ],
    'OTZ'  => [  4,   0.,   99.99,    undef,    undef,   0.01,  1 ],
    'OSV'  => [  5,   0.,  40.999,    undef,    undef,  0.001,  1 ],
    'OSZ'  => [  4,   0.,   99.99,    undef,    undef,   0.01,  1 ],
    'OOV'  => [  4,   0.,   12.99,    undef,    undef,   0.01,  1 ],
    'OOZ'  => [  4,   0.,   99.99,    undef,    undef,   0.01,  1 ],
    'OPV'  => [  4,   0.,   30.99,    undef,    undef,   0.01,  1 ],
    'OPZ'  => [  4,   0.,   99.99,    undef,    undef,   0.01,  1 ],
    'OSIV' => [  5,   0.,  250.99,    undef,    undef,   0.01,  1 ],
    'OSIZ' => [  4,   0.,   99.99,    undef,    undef,   0.01,  1 ],
    'ONV'  => [  5,   0.,  500.99,    undef,    undef,   0.01,  1 ],
    'ONZ'  => [  4,   0.,   99.99,    undef,    undef,   0.01,  1 ],
    'OPHV' => [  3,  6.2,     9.2,    undef,    undef,   0.01,  1 ],
    'OPHZ' => [  4,   0.,   99.99,    undef,    undef,   0.01,  1 ],
    'OCV'  => [  4,   0.,   50.99,    undef,    undef,   0.01,  1 ],
    'OCZ'  => [  4,   0.,   99.99,    undef,    undef,   0.01,  1 ],
    'OAV'  => [  3,   0.,     3.1,    undef,    undef,   0.01,  1 ],
    'OAZ'  => [  4,   0.,   99.99,    undef,    undef,   0.01,  1 ],
    'OPCV' => [  4,   0.,    999.,    undef,    undef,    0.1,  1 ],
    'OPCZ' => [  4,   0.,   99.99,    undef,    undef,   0.01,  1 ],
    'ODV'  => [  2,   0.,      4.,    undef,    undef,    0.1,  1 ],
    'ODZ'  => [  4,   0.,   99.99,    undef,    undef,   0.01,  1 ],
    'PUID' => [ 10, undef,  undef,    undef,    undef,  undef,  3 ]
);

