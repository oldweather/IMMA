# Data for IMMA attachment 5 - Historical
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

class IMMAHistorical:

	attachment = 'historical'
	number = 5

# List of parameters in icoads section
# In the order they are in on disc
	parameters = ('WFI','WF','XWI','XW','XDI','XD','SLPI','TAI','TA','XNI','XN')

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
	definitions = {
    'WFI'  : ( 1,  None,  None,  None,  None,  None, 1 ),
    'WF'   : ( 2,  None,  None,  None,  None,  None, 1 ),
    'XWI'  : ( 1,  None,  None,  None,  None,  None, 1 ),
    'XW'   : ( 3,  None,  None,  None,  None, 0.1,   1 ),
    'XDI'  : ( 1,  None,  None,  None,  None,  None, 1 ),
    'XD'   : ( 2,  None,  None,  None,  None,  None, 1 ),
    'SLPI' : ( 1,  None,  None,  None,  None,  None, 1 ),
    'TAI'  : ( 1,  None,  None,  None,  None,  None, 1 ),
    'TA'   : ( 4,  None,  None,  None,  None,  None, 1 ),
    'XNI'  : ( 1,  None,  None,  None,  None,  None, 1 ),
    'XN'   : ( 2,  None,  None,  None,  None,  None, 1 )
    }

