# Python module for handling IMMA data
#  IMMA documentation is at http://icoads.noaa.gov/e-doc/imma

import re     #  Regular Expressions

class IMMA:
   
    def __init__(self):          # Standard instance object
        self.attachments = []    # List of attachments in this instance
        self.data = {}           # Dictionary to hold the parameter values

# Getter and setter for instance parameters
    def __getitem__(self, key): return self.data[key]
    def __setitem__(self, key, item): self.data[key] = item

 # Read in a record from a file
    def read(self,fh):
        line = fh.readline();
        if(line == ""): return   # EOF
        line=line.rstrip("\n")       # Remove trailing newline
    
    # Core is always present (and first)
        Attachment = 0;
        Length     = 108;

    # Decode each attachment
        while ( len(line) > 0 ):

            # Pad the string with blanks if it's too short
            if ( Length != None and Length > 0 and len(line) < Length ):
                sfmt = "%%%ds" % (Length-len(line))
                line += sfmt % " "

            self.decode(
                line,
                getAttachment(Attachment),
                getParameters(Attachment),
                getDefinitions(Attachment)
            )
            self.attachments.append(int(Attachment))
            if ( Length==None or Length == 0 ):
                break
            line = line[Length:len(line)]
            if ( len(line) > 0 ):
                Attachment = int(line[0:2])
                Length     = line[2:4]
                if( re.search("\S",Length)==None): 
                    Length = None
                if ( Length != None ):
                    Length = int(Length)
                    if ( Length != 0 ):
                        Length = int(Length)-4
                        line = line[4:len(line)]
                if(getAttachment(Attachment)==None ):
                    raise("Bad IMMA string","Unsupported attachment ID "+Attachment)

        return 1

# Write out a record to a file
    def write(self,fh):           # fh is a filehandle
        Result = ""
        for Attachment in self.attachments:
            Result += self.encode(
                Attachment,
                getParameters(Attachment),
                getDefinitions(Attachment)
            )
        Result=Result.rstrip()
        fh.write( Result+"\n" )
        return 1

# Extract the parameter values from the string representation
#  of an attachment
    def decode(self,
               as_string,      # String representation of the attachment
               attachment,     # Attachment name
               parameters,     # Attachment parameter array
               definitions):   # Attachment definitions hash
        if( as_string== None ):
            raise("Bad IMMA string","No data to decode")

        Position = 0;
        for i in range(len(parameters)):
            if ( definitions[parameters[i]][0] != None ):
                self[parameters[i]] = as_string[Position:Position+definitions[parameters[i]][0]]
                Position += definitions[parameters[i]][0]
            else:                  # Undefined length - so slurp all the data
                self[parameters[i]] = as_string[Position:len(as_string)]
                self[parameters[i]] = self[parameters[i]].rstrip("\n")
                Position = len(as_string)

        # Blanks mean value is undefined
            if( re.search("\S",self[parameters[i]]) == None ):
                self[parameters[i]] = None
                continue    #  Next parameter

            if ( definitions[parameters[i]][6] == 2 ):
                self[parameters[i]] = decode_base36(self[parameters[i]])
                
            if ( definitions[parameters[i]][6] == 1 ):
                self[parameters[i]] = int(self[parameters[i]])
                
            if ( definitions[parameters[i]][5] != None and
                 definitions[parameters[i]][5] != 1.0 ):
                self[parameters[i]] = int(self[parameters[i]])*definitions[parameters[i]][5];


# Make a string representation of an attachment
    def encode (self,
                attachment,    # Attachment number
                parameters,    # Ref to attachment parameter array
                definitions):  # Ref to attachment definitions hash
        Result = ""
        for i in range(len(parameters)):
            if ( self[parameters[i]] != None):
                Tmp = self[parameters[i]]

                # Scale to integer units for output
                if ( definitions[parameters[i]][5] != None ):
                    Tmp /= definitions[parameters[i]][5];
                    Tmp = int(Tmp+0.5)  # nint

                # Encode as base36 if required
                if ( definitions[parameters[i]][6] == 2 ):
                    Tmp = encode_base36(Tmp);

                # Print as an string of the correct length
                if ( definitions[parameters[i]][6] == 1 ):  # Integer

                    if ( definitions[parameters[i]][0] != None ):
                        Lstring = "%%%dd" % (definitions[parameters[i]][0])
                        Tmp = Lstring % (Tmp)
                    else:
                        # Undefined length - don't try to constrain it
                        Tmp = "%d" % (Tmp)

                else:                                      # String

                    if ( definitions[parameters[i]][0] != None ):
                        Lstring = "%%-%ds" % (definitions[parameters[i]][0])
                        Tmp = Lstring % (Tmp)
                    else:
                        Tmp = "%-s" % (Tmp)

                Result += Tmp

            else:  # Undefined data - make a blank string of the corect length

                if ( definitions[parameters[i]][0] != None ):
                    Lstring = "%%%ds" % (definitions[parameters[i]][0])
                    Result += Lstring % (" ")

                else: # Undefined data with unknown length - should never happen
                    Result += " ";

    # Done all the parameters, add the ID and length to the start
    # (except for core)
        if ( attachment != 0 ):
            if ( attachment != 99 ):
                Result = "%2d%2d%s" % (attachment, len(Result) + 4, Result)
            else:
                Result = "%2d 0%s" % (attachment, Result)

        return Result

# Functions in the IMMA namespace, but outside the class

# Create a record and read it in from a file
def read(fh):           # fh is a filehandle 
    imma_local = IMMA()
    imma_local.read(fh)
    return imma_local

def getAttachment(i):
    return attachment["%02d" % i]
def getParameters(i):
    return parameters["%02d" % i]
def getDefinitions(i):
    return definitions["%02d" % i]

# Convert a single-digit base36 value to base 10
def decode_base36(t): 
    return '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'.find(t)

# Convert a base 10 value in the range 0-35 to base36
def encode_base36(t):
    return '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'[t:t+1]


###
### Data for each attachment type
###

attachment  = {}  # Dictionaries, so indexed by %02d string
parameters  = {}
definitions = {}

#
# Core attachment
#
attachment['00'] = 'core'

# List of parameters in core section
# In the order they are in on disc
parameters['00'] = ('YR','MO','DY','HR','LAT','LON','IM','ATTC',
                  'TI','LI','DS','VS','NID','II','ID','C1','DI',
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
definitions['00'] = {
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

#
# ICOADS attachment
#

attachment['01'] = 'icoads'

# List of parameters in icoads section
# In the order they are in on disc
parameters['01'] = ('BSI','B10','B1','DCK','SID','PT','DUPS','DUPC','TC',
	              'PB','WX','SX','C2','SQZ','SQA','AQZ','AQA','UQZ','UQA',
	              'VQZ','VQA','PQZ','PQA','DQZ','DQA','ND','SF','AF',
	              'UF','VF','PF','RF','ZNC','WNC','BNC','XNC','YNC',
	              'PNC','ANC','GNC','DNC','SNC','CNC','ENC','FNC','TNC',
	              'QCE','LZ','QCZ')

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
definitions['01'] = {
    'BSI'  : ( 1,  None,  None,  None,  None, 1., 1 ),
    'B10'  : ( 3, 1.,    648.,   None,  None, 1., 1 ),
    'B1'   : ( 2, 0.,    99.,    None,  None, 1., 1 ),
    'DCK'  : ( 3, 0.,    999.,   None,  None, 1., 1 ),
    'SID'  : ( 3, 0.,    999.,   None,  None, 1., 1 ),
    'PT'   : ( 2, 0.,    15.,    None,  None, 1., 1 ),
    'DUPS' : ( 2, 0.,    14.,    None,  None, 1., 1 ),
    'DUPC' : ( 1, 0.,    2.,     None,  None, 1., 1 ),
    'TC'   : ( 1, 0.,    1.,     None,  None, 1., 1 ),
    'PB'   : ( 1, 0.,    2.,     None,  None, 1., 1 ),
    'WX'   : ( 1, 1.,    1.,     None,  None, 1., 1 ),
    'SX'   : ( 1, 1.,    1.,     None,  None, 1., 1 ),
    'C2'   : ( 2, 0.,    40.,    None,  None, 1., 1 ),
    'SQZ'  : ( 1, 1.,    35.,    None,  None, 1., 2 ),
    'SQA'  : ( 1, 1.,    21.,    None,  None, 1., 2 ),
    'AQZ'  : ( 1, 1.,    35.,    None,  None, 1., 2 ),
    'AQA'  : ( 1, 1.,    21.,    None,  None, 1., 2 ),
    'UQZ'  : ( 1, 1.,    35.,    None,  None, 1., 2 ),
    'UQA'  : ( 1, 1.,    21.,    None,  None, 1., 2 ),
    'VQZ'  : ( 1, 1.,    35.,    None,  None, 1., 2 ),
    'VQA'  : ( 1, 1.,    21.,    None,  None, 1., 2 ),
    'PQZ'  : ( 1, 1.,    35.,    None,  None, 1., 2 ),
    'PQA'  : ( 1, 1.,    21.,    None,  None, 1., 2 ),
    'DQZ'  : ( 1, 1.,    35.,    None,  None, 1., 2 ),
    'DQA'  : ( 1, 1.,    21.,    None,  None, 1., 2 ),
    'ND'   : ( 1, 1.,    2.,     None,  None, 1., 1 ),
    'SF'   : ( 1, 1.,    15.,    None,  None, 1., 2 ),
    'AF'   : ( 1, 1.,    15.,    None,  None, 1., 2 ),
    'UF'   : ( 1, 1.,    15.,    None,  None, 1., 2 ),
    'VF'   : ( 1, 1.,    15.,    None,  None, 1., 2 ),
    'PF'   : ( 1, 1.,    15.,    None,  None, 1., 2 ),
    'RF'   : ( 1, 1.,    15.,    None,  None, 1., 2 ),
    'ZNC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'WNC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'BNC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'XNC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'YNC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'PNC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'ANC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'GNC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'DNC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'SNC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'CNC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'ENC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'FNC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'TNC'  : ( 1, 1.,    10.,    None,  None, 1., 2 ),
    'QCE'  : ( 2, 0.,    63.,    None,  None, 1., 1 ),
    'LZ'   : ( 1, 1.,    1.,     None,  None, 1., 1 ),
    'QCZ'  : ( 2, 0.,    31.,    None,  None, 1., 1 )
	}

#
# IMMT2 attachment
#

attachment['02'] = 'immt2'

# List of parameters in IMMT2 section
# In the order they are in on disc
parameters['02'] = ('OS','OP','FM','IX','W2','SGN','SGT','SGH',
                  'WMI','SD2','SP2','SH2','IS','ES','RS','IC1',
                  'IC2','IC3','IC4','IC5','IR','RRR','TR','QCI',
                  'QI1','QI2','QI3','QI4','QI5','QI6','QI7','QI8',
                  'QI9','QI10','QI11','QI12','QI13','QI14','QI15',
                  'QI16','QI17','QI18','QI19','QI20','QI21','HDG',
                  'COG','SOG','SLL','SLHH','RWD','RWS')

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
definitions['02'] = {
    'OS'   : ( 1, 0.,   6.,   None,  None,  1.,  1 ),
    'OP'   : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'FM'   : ( 2, 0.,   8.,   None,  None,  1.,  1 ),
    'IX'   : ( 1, 1.,   7.,   None,  None,  1.,  1 ),
    'W2'   : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'SGN'  : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'SGT'  : ( 1, 0.,   10.,  None,  None,  1.,  2 ),
    'SGH'  : ( 2, 0.,   50.,  56.,   99.,   1.,  1 ),
    'WMI'  : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'SD2'  : ( 2, 0.,   38.,  None,  None,  1.,  1 ),
    'SP2'  : ( 2, 0.,   30.,  99.,   99.,   1.,  1 ),
    'SH2'  : ( 2, 0.,   99.,  None,  None,  1.,  1 ),
    'IS'   : ( 1, 1.,   5.,   None,  None,  1.,  1 ),
    'ES'   : ( 2, 0.,   99.,  None,  None,  1.,  1 ),
    'RS'   : ( 1, 0.,   4.,   None,  None,  1.,  1 ),
    'IC1'  : ( 1, 0.,   10.,  None,  None,  1.,  2 ),
    'IC2'  : ( 1, 0.,   10.,  None,  None,  1.,  2 ),
    'IC3'  : ( 1, 0.,   10.,  None,  None,  1.,  2 ),
    'IC4'  : ( 1, 0.,   10.,  None,  None,  1.,  2 ),
    'IC5'  : ( 1, 0.,   10.,  None,  None,  1.,  2 ),
    'IR'   : ( 1, 0.,   4.,   None,  None,  1.,  1 ),
    'RRR'  : ( 3, 0.,   999., None,  None,  1.,  1 ),
    'TR'   : ( 1, 1.,   9.,   None,  None,  1.,  1 ),
    'QCI'  : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI1'  : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI2'  : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI3'  : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI4'  : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI5'  : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI6'  : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI7'  : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI8'  : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI9'  : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI10' : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI11' : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI12' : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI13' : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI14' : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI15' : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI16' : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI17' : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI18' : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI19' : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI20' : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'QI21' : ( 1, 0.,   9.,   None,  None,  1.,  1 ),
    'HDG'  : ( 3, 0.,   360., None,  None,  1.,  1 ),
    'COG'  : ( 3, 0.,   360., None,  None,  1.,  1 ),
    'SOG'  : ( 2, 0.,   99.,  None,  None,  1.,  1 ),
    'SLL'  : ( 2, 0.,   99.,  None,  None,  1.,  1 ),
    'SLHH' : ( 3, -99., 99.,  None,  None,  1.,  1 ),
    'RWD'  : ( 3, 1.,   362., None,  None,  1.,  1 ),
    'RWS'  : ( 3, 0.0,  99.9, None,  None,  0.1, 1 )
	}

#
# Model Quality Control attachment
#

attachment['03'] = 'mqc'

# List of parameters in mqc section
# In the order they are in on disc
parameters['03'] = ('CCCC','BUID','BMP','BSWU','SWU','BSWV','SWV','BSAT',
                    'BSRH','SRH','SIX','BSST','MST','MSH','BY','BM','BD',
                    'BH','BFL')

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
definitions['03'] = {
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

#
# Metadata attachment
#

attachment['04'] = 'metadata'

# List of parameters in metadata section
# In the order they are in on disc
parameters['04'] = ('C1M','OPM','KOV','COR','TOB','TOT','EOT','LOT','TOH','EOH',
	                'SIM','LOV','DOS','HOP','HOT','HOB','HOA','SMF','SME','SMV')

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
definitions['04'] = {
    'C1M' : ( 2, 65., 90.,    None,  None,  None,  3 ),
    'OPM' : ( 2, 0.,  99.,    None,  None,  1.,    1 ),
    'KOV' : ( 2, 32., 126.,   None,  None,  None,  3 ),
    'COR' : ( 2, 65., 90.,    None,  None,  None,  3 ),
    'TOB' : ( 3, 32., 126.,   None,  None,  None,  3 ),
    'TOT' : ( 3, 32., 126.,   None,  None,  None,  3 ),
    'EOT' : ( 2, 32., 126.,   None,  None,  None,  3 ),
    'LOT' : ( 2, 32., 126.,   None,  None,  None,  3 ),
    'TOH' : ( 1, 32., 126.,   None,  None,  None,  3 ),
    'EOH' : ( 2, 32., 126.,   None,  None,  None,  3 ),
    'SIM' : ( 3, 32., 126.,   None,  None,  None,  3 ),
    'LOV' : ( 3, 0.,  999.,   None,  None,  1.,    1 ),
    'DOS' : ( 2, 0.,  99.,    None,  None,  1.,    1 ),
    'HOP' : ( 3, 0.,  999.,   None,  None,  1.,    1 ),
    'HOT' : ( 3, 0.,  999.,   None,  None,  1.,    1 ),
    'HOB' : ( 3, 0.,  999.,   None,  None,  1.,    1 ),
    'HOA' : ( 3, 0.,  999.,   None,  None,  1.,    1 ),
    'SMF' : ( 5, 0.,  99999., None,  None,  1.,    1 ),
    'SME' : ( 5, 0.,  99999., None,  None,  1.,    1 ),
    'SMV' : ( 2, 0.,  99.,    None,  None,  1.,    1 )
    }

#
# Historical attachment
#

attachment['05'] = 'historical'

# List of parameters in historical section
# In the order they are in on disc
parameters['05'] = ('WFI','WF','XWI','XW','XDI','XD','SLPI','TAI','TA','XNI','XN')

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
definitions['05'] = {
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

#
# Supplemental data attachment
#

attachment['99'] = 'supplemental'

# List of parameters in supplemental section
# In the order they are in on disc
parameters['99'] = ('ATTE','SUPD');

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
definitions['99'] = {
    'ATTE' : ( 1,     None,  None,  None,  None,  None,  1 ),
    'SUPD' : ( None,  None,  None,  None,  None,  None,  3 )
	}


