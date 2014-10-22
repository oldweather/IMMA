# Data for IMMA attachment 3 - Model Quality Control
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

class IMMAMqc:

	attachment = 'mqc';
	number = 3

# List of parameters in icoads section
# In the order they are in on disc
	parameters = ('CCCC','BUID','BMP','BSWU','SWU','BSWV','SWV','BSAT',
              'BSRH','SRH','SIX','BSST','MST','MSH','BY','BM','BD','BH','BFL')

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
	definitions = {
    'CCCC' : ( 4, 65.,   90.,    None,  None,  None,  3 ),
    'BUID' : ( 6, 48.,   57.,    65.,   90.,   None,  3 ),
    'BMP'  : ( 5, 870.0, 1074.6, None,  None,  0.1,   1 ),
    'BSWU' : ( 4, -99.9, 99.9,   None,  None,  0.1,   1 ),
    'SWU'  : ( 4, -99.9, 99.9,   None,  None,  0.1,   1 ),
    'BSWV' : ( 4, -99.9, 99.9,   None,  None,  0.1,   1 ),
    'SWV'  : ( 4, -99.9, 99.9,   None,  None,  0.1,   1 ),
    'BSAT' : ( 4, -99.9, 99.9,   None,  None,  0.1,   1 ),
    'BSRH' : ( 3, 0.,    100.,   None,  None,  1.,    1 ),
    'SRH'  : ( 3, 0.,    100.,   None,  None,  1.,    1 ),
    'SIX'  : ( 1, 2.,    3.,     None,  None,  1.,    1 ),
    'BSST' : ( 4, -99.9, 99.9,   None,  None,  0.1,   1 ),
    'MST'  : ( 1, 0.,    9.,     None,  None,  1.,    1 ),
    'MSH'  : ( 3, 0.,    999.,   None,  None,  1.,    1 ),
    'BY'   : ( 4, 0.,    9999.,  None,  None,  1.,    1 ),
    'BM'   : ( 2, 1.,    12.,    None,  None,  1.,    1 ),
    'BD'   : ( 2, 1.,    31.,    None,  None,  1.,    1 ),
    'BH'   : ( 2, 0.,    23.,    None,  None,  1.,    1 ),
    'BFL'  : ( 2, 0.,    99.,    None,  None,  1.,    1 )
	}

