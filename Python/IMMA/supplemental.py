# Data for IMMA attachment 99 - Supplemental
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

class IMMASupplemental:


	attachment = 'supplemental'
	number = 99

# List of parameters in icoads section
# In the order they are in on disc
	parameters = ('ATTE','SUPD');

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
	definitions = {
    'ATTE' : ( 1,     None,  None,  None,  None,  None,  1 ),
    'SUPD' : ( None,  None,  None,  None,  None,  None,  3 )
	}

