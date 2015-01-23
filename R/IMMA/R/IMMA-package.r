#' IMMA.
#'
#' @name IMMA
#' @docType package

# Definitions of the attachments
IMMA.attachments <- list();
IMMA.parameters  <- list();
IMMA.definitions <- list();

# Core section
IMMA.attachments[[1]] <- 'core';

# List of parameters in core section
# In the order they are in on disc
IMMA.parameters[[1]] <- c('YR','MO','DY','HR','LAT','LON','IM','ATTC',
                          'TI','LI','DS','VS','NID','II','ID','C1',
			  'DI','D','WI','W','VI','VV','WW','W1',
                          'SLP','A','PPP','IT','AT','WBTI','WBT',
		          'DPTI','DPT','SI','SST','N','NH','CL',
		          'HI','H','CM','CH','WD','WP','WH','SD',
		          'SP','SH');

# For each parameter, provide an array specifying:
#    Its length in bytes, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
IMMA.definitions[[1]] <- list(
    'YR'   = list( 4, 1600.,  2024.,  NULL,    NULL,   1.,    1 ),
    'MO'   = list( 2, 1.,     12.,    NULL,    NULL,   1.,    1 ),
    'DY'   = list( 2, 1.,     31.,    NULL,    NULL,   1.,    1 ),
    'HR'   = list( 4, 0.00,   23.99,  NULL,    NULL,   0.01,  1 ),
    'LAT'  = list( 5, -90.00, 90.00,  NULL,    NULL,   0.01,  1 ),
    'LON'  = list( 6, 0.00,   359.99, -179.99, 180.00, 0.01,  1 ),
    'IM'   = list( 2, 0.,     99.,    NULL,    NULL,   1.,    1 ),
    'ATTC' = list( 1, 0.,     9.,     NULL,    NULL,   1.,    1 ),
    'TI'   = list( 1, 0.,     3.,     NULL,    NULL,   1.,    1 ),
    'LI'   = list( 1, 0.,     6.,     NULL,    NULL,   1.,    1 ),
    'DS'   = list( 1, 0.,     9.,     NULL,    NULL,   1.,    1 ),
    'VS'   = list( 1, 0.,     9.,     NULL,    NULL,   1.,    1 ),
    'NID'  = list( 2, 0.,     99.,    NULL,    NULL,   1.,    1 ),
    'II'   = list( 2, 0.,     10.,    NULL,    NULL,   1.,    1 ),
    'ID'   = list( 9, 32.,    126.,   NULL,    NULL,   NULL,  3 ),
    'C1'   = list( 2, 48.,    57.,    65.,     90.,    NULL,  3 ),
    'DI'   = list( 1, 0.,     6.,     NULL,    NULL,   1.,    1 ),
    'D'    = list( 3, 1.,     362.,   NULL,    NULL,   1.,    1 ),
    'WI'   = list( 1, 0.,     8.,     NULL,    NULL,   1.,    1 ),
    'W'    = list( 3, 0.0,    99.9,   NULL,    NULL,   0.1,   1 ),
    'VI'   = list( 1, 0.,     2.,     NULL,    NULL,   1.,    1 ),
    'VV'   = list( 2, 90.,    99.,    NULL,    NULL,   1.,    1 ),
    'WW'   = list( 2, 0.,     99.,    NULL,    NULL,   1.,    1 ),
    'W1'   = list( 1, 0.,     9.,     NULL,    NULL,   1.,    1 ),
    'SLP'  = list( 5, 870.0,  1074.6, NULL,    NULL,   0.1,   1 ),
    'A'    = list( 1, 0.,     8.,     NULL,    NULL,   1.,    1 ),
    'PPP'  = list( 3, 0.0,    51.0,   NULL,    NULL,   0.1,   1 ),
    'IT'   = list( 1, 0.,     9.,     NULL,    NULL,   1.,    1 ),
    'AT'   = list( 4, -99.9,  99.9,   NULL,    NULL,   0.1,   1 ),
    'WBTI' = list( 1, 0.,     3.,     NULL,    NULL,   1.,    1 ),
    'WBT'  = list( 4, -99.9,  99.9,   NULL,    NULL,   0.1,   1 ),
    'DPTI' = list( 1, 0.,     3.,     NULL,    NULL,   1.,    1 ),
    'DPT'  = list( 4, -99.9,  99.9,   NULL,    NULL,   0.1,   1 ),
    'SI'   = list( 2, 0.,     12.,    NULL,    NULL,   1.,    1 ),
    'SST'  = list( 4, -99.9,  99.9,   NULL,    NULL,   0.1,   1 ),
    'N'    = list( 1, 0.,     9.,     NULL,    NULL,   1.,    1 ),
    'NH'   = list( 1, 0.,     9.,     NULL,    NULL,   1.,    1 ),
    'CL'   = list( 1, 0.,     10.,    NULL,    NULL,   1.,    2 ),
    'HI'   = list( 1, 0.,     1.,     NULL,    NULL,   1.,    1 ),
    'H'    = list( 1, 0.,     10.,    NULL,    NULL,   1.,    2 ),
    'CM'   = list( 1, 0.,     10.,    NULL,    NULL,   1.,    2 ),
    'CH'   = list( 1, 0.,     10.,    NULL,    NULL,   1.,    2 ),
    'WD'   = list( 2, 0.,     38.,    NULL,    NULL,   1.,    1 ),
    'WP'   = list( 2, 0.,     30.,    99.,     99.,    1.,    1 ),
    'WH'   = list( 2, 0.,     99.,    NULL,    NULL,   1.,    1 ),
    'SD'   = list( 2, 0.,     38.,    NULL,    NULL,   1.,    1 ),
    'SP'   = list( 2, 0.,     30.,    99.,     99.,    1.,    1 ),
    'SH'   = list( 2, 0.,     99.,    NULL,    NULL,   1.,    1 )
)

// Find out which attachment a parameter is in
IMMA.whichAttachment = function(parameter) {
    for(i in [0,1,2,3,4,5,99]) {
        if(IMMA.definitions[i][parameter]!=null) { return i; }
    }
    throw new Error("No parameter "+parameter+" in IMMA");
}

// Get the definitions for a named parameter
IMMA.definitionsFor = function(parameter) {
    var attachment = IMMA.whichAttachment(parameter);
    return IMMA.definitions[attachment];
}



#' Read in all the IMMA records from a connection
#'
#' Currently only reads the core element - discards attachments
#'
#' I'm not sure how to read variable-format records in an efficient fashion
#'  so at the moment this only looks at the fixed-format component.
#'
#' @export
#' @param con Connection to read data from.
#' @param n - maximum number of records to read (negative means read all)
#'   repeatedly call with n=1 to get records 1 at a time, use n=-1
#'   (default) to get them all in one go.
#' @return data frame - 1 row per record, column names as in the IMMA
#'  documentation.
IMMA.read<-function(con,n=-1) {
