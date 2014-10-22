# Define a class describing an IMMA record
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

class IMMACore:
    
# Name of the attachment
	attachment = 'core'
# Number of the attachment
	number = 0

# List of parameters in core section
# In the order they are in on disc
	parameters = ('YR','MO','DY','HR','LAT','LON','IM','ATTC',
                  'TI','LI','DS','VS','ID','II','ID','C1','DI',
                  'D','WI','W','VI','VV','WW','W1','SLP','A',
                  'PPP','IT','AT','WBTI','WBT','DPTI','DPT','SI',
                  'SST','N','NH','CL','HI','H','CM','CH','WD',
                  'WP','WH','SD','SP','SH')

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
	definitions = {
    'YR'   : ( 4, 1600.,  2024.,   None,    None,  1.,    1 ),
    'MO'   : ( 2, 1.,     12.,     None,    None,  1.,    1 ),
    'DY'   : ( 2, 1.,     31.,     None,    None,  1.,    1 ),
    'HR'   : ( 4, 0.00,   23.99,   None,    None,  0.01,  1 ),
    'LAT'  : ( 5, -90.00, 90.00,   None,    None,  0.01,  1 ),
    'LON'  : ( 6, 0.00,   359.99, -179.99, 180.00, 0.01,  1 ),
    'IM'   : ( 2, 0.,     99.,     None,    None,  1.,    1 ),
    'ATTC' : ( 1, 0.,     9.,      None,    None,  1.,    1 ),
    'TI'   : ( 1, 0.,     3.,      None,    None,  1.,    1 ),
    'LI'   : ( 1, 0.,     6.,      None,    None,  1.,    1 ),
    'DS'   : ( 1, 0.,     9.,      None,    None,  1.,    1 ),
    'VS'   : ( 1, 0.,     9.,      None,    None,  1.,    1 ),
    'NID'  : ( 2, 0.,     99.,     None,    None,  1.,    1 ),
    'II'   : ( 2, 0.,     10.,     None,    None,  1.,    1 ),
    'ID'   : ( 9, 32.,    126.,    None,    None,   None, 3 ),
    'C1'   : ( 2, 48.,    57.,    65.,     90.,     None, 3 ),
    'DI'   : ( 1, 0.,     6.,      None,    None,  1.,    1 ),
    'D'    : ( 3, 1.,     362.,    None,    None,  1.,    1 ),
    'WI'   : ( 1, 0.,     8.,      None,    None,  1.,    1 ),
    'W'    : ( 3, 0.0,    99.9,    None,    None,  0.1,   1 ),
    'VI'   : ( 1, 0.,     2.,      None,    None,  1.,    1 ),
    'VV'   : ( 2, 90.,    99.,     None,    None,  1.,    1 ),
    'WW'   : ( 2, 0.,     99.,     None,    None,  1.,    1 ),
    'W1'   : ( 1, 0.,     9.,      None,    None,  1.,    1 ),
    'SLP'  : ( 5, 870.0,  1074.6,  None,    None,  0.1,   1 ),
    'A'    : ( 1, 0.,     8.,      None,    None,  1.,    1 ),
    'PPP'  : ( 3, 0.0,    51.0,    None,    None,  0.1,   1 ),
    'IT'   : ( 1, 0.,     9.,      None,    None,  1.,    1 ),
    'AT'   : ( 4, -99.9,  99.9,    None,    None,  0.1,   1 ),
    'WBTI' : ( 1, 0.,     3.,      None,    None,  1.,    1 ),
    'WBT'  : ( 4, -99.9,  99.9,    None,    None,  0.1,   1 ),
    'DPTI' : ( 1, 0.,     3.,      None,    None,  1.,    1 ),
    'DPT'  : ( 4, -99.9,  99.9,    None,    None,  0.1,   1 ),
    'SI'   : ( 2, 0.,     12.,     None,    None,  1.,    1 ),
    'SST'  : ( 4, -99.9,  99.9,    None,    None,  0.1,   1 ),
    'N'    : ( 1, 0.,     9.,      None,    None,  1.,    1 ),
    'NH'   : ( 1, 0.,     9.,      None,    None,  1.,    1 ),
    'CL'   : ( 1, 0.,     10.,     None,    None,  1.,    2 ),
    'HI'   : ( 1, 0.,     1.,      None,    None,  1.,    1 ),
    'H'    : ( 1, 0.,     10.,     None,    None,  1.,    2 ),
    'CM'   : ( 1, 0.,     10.,     None,    None,  1.,    2 ),
    'CH'   : ( 1, 0.,     10.,     None,    None,  1.,    2 ),
    'WD'   : ( 2, 0.,     38.,     None,    None,  1.,    1 ),
    'WP'   : ( 2, 0.,     30.,    99.,     99.,    1.,    1 ),
    'WH'   : ( 2, 0.,     99.,     None,    None,  1.,    1 ),
    'SD'   : ( 2, 0.,     38.,     None,    None,  1.,    1 ),
    'SP'   : ( 2, 0.,     30.,    99.,     99.,    1.,    1 ),
    'SH'   : ( 2, 0.,     99.,     None,    None,  1.,    1 )
	}


