# Specification of the file format

# Name of each attachment, from its numerical code
#  except for core 0->'C0' as array element 0 not allowed in R
attachments <- character(0)

# Parameter definitions
# For each attachment, a list of all parameters in that attachment
#  For each parameter, a list specifying
#    Its length in characters, on disc,
#    Its minimum value
#    Its maximum value
#    Its minimum value (alternative representation)
#    Its maximum value (alternative representation)
#    Its units scale
#    Its encoding (1 = integer, 3= character, 2= base36)
definitions <- list()

# Core section
#attachments[0] <- 'C0' # Core section - 
definitions[['C0']] <- list(
    'YR'   = list( 4,  1600.,   2024.,      NA,      NA,    1.,    1 ),
    'MO'   = list( 2,     1.,     12.,      NA,      NA,    1.,    1 ),
    'DY'   = list( 2,     1.,     31.,      NA,      NA,    1.,    1 ),
    'HR'   = list( 4,   0.00,   23.99,      NA,      NA,  0.01,    1 ),
    'LAT'  = list( 5, -90.00,   90.00,      NA,      NA,  0.01,    1 ),
    'LON'  = list( 6,   0.00,  359.99, -179.99,  180.00,  0.01,    1 ),
    'IM'   = list( 2,     0.,     99.,      NA,      NA,    1.,    1 ),
    'ATTC' = list( 1,     0.,     36.,      NA,      NA,    1.,    2 ),
    'TI'   = list( 1,     0.,      3.,      NA,      NA,    1.,    1 ),
    'LI'   = list( 1,     0.,      6.,      NA,      NA,    1.,    1 ),
    'DS'   = list( 1,     0.,      9.,      NA,      NA,    1.,    1 ),
    'VS'   = list( 1,     0.,      9.,      NA,      NA,    1.,    1 ),
    'NID'  = list( 2,     0.,     99.,      NA,      NA,    1.,    1 ),
    'II'   = list( 2,     0.,     10.,      NA,      NA,    1.,    1 ),
    'ID'   = list( 9,     NA,      NA,      NA,      NA,    NA,    3 ),
    'C1'   = list( 2,     NA,      NA,      NA,      NA,    NA,    3 ),
    'DI'   = list( 1,     0.,      6.,      NA,      NA,    1.,    1 ),
    'D'    = list( 3,     1.,    362.,      NA,      NA,    1.,    1 ),
    'WI'   = list( 1,     0.,      8.,      NA,      NA,    1.,    1 ),
    'W'    = list( 3,    0.0,    99.9,      NA,      NA,   0.1,    1 ),
    'VI'   = list( 1,     0.,      2.,      NA,      NA,    1.,    1 ),
    'VV'   = list( 2,    90.,     99.,      NA,      NA,    1.,    1 ),
    'WW'   = list( 2,     0.,     99.,      NA,      NA,    1.,    1 ),
    'W1'   = list( 1,     0.,      9.,      NA,      NA,    1.,    1 ),
    'SLP'  = list( 5,  870.0,  1074.6,      NA,      NA,   0.1,    1 ),
    'A'    = list( 1,     0.,      8.,      NA,      NA,    1.,    1 ),
    'PPP'  = list( 3,    0.0,    51.0,      NA,      NA,   0.1,    1 ),
    'IT'   = list( 1,     0.,      9.,      NA,      NA,    1.,    1 ),
    'AT'   = list( 4,  -99.9,    99.9,      NA,      NA,   0.1,    1 ),
    'WBTI' = list( 1,     0.,      3.,      NA,      NA,    1.,    1 ),
    'WBT'  = list( 4,  -99.9,    99.9,      NA,      NA,   0.1,    1 ),
    'DPTI' = list( 1,     0.,      3.,      NA,      NA,    1.,    1 ),
    'DPT'  = list( 4,  -99.9,    99.9,      NA,      NA,   0.1,    1 ),
    'SI'   = list( 2,     0.,     12.,      NA,      NA,    1.,    1 ),
    'SST'  = list( 4,  -99.9,    99.9,      NA,      NA,   0.1,    1 ),
    'N'    = list( 1,     0.,      9.,      NA,      NA,    1.,    1 ),
    'NH'   = list( 1,     0.,      9.,      NA,      NA,    1.,    1 ),
    'CL'   = list( 1,     0.,     10.,      NA,      NA,    1.,    2 ),
    'HI'   = list( 1,     0.,      1.,      NA,      NA,    1.,    1 ),
    'H'    = list( 1,     0.,     10.,      NA,      NA,    1.,    2 ),
    'CM'   = list( 1,     0.,     10.,      NA,      NA,    1.,    2 ),
    'CH'   = list( 1,     0.,     10.,      NA,      NA,    1.,    2 ),
    'WD'   = list( 2,     0.,     38.,      NA,      NA,    1.,    1 ),
    'WP'   = list( 2,     0.,     30.,     99.,     99.,    1.,    1 ),
    'WH'   = list( 2,     0.,     99.,      NA,      NA,    1.,    1 ),
    'SD'   = list( 2,     0.,     38.,      NA,      NA,    1.,    1 ),
    'SP'   = list( 2,     0.,     30.,     99.,     99.,    1.,    1 ),
    'SH'   = list( 2,     0.,     99.,      NA,      NA,    1.,    1 )
)
#ICOADS attachment
attachments[1] = 'C1'  # 'ICOADS'
definitions[['C1']] = list(
    'BSI'  = list( 1,   NA,    NA,    NA,   NA,   NA, 3 ),
    'B10'  = list( 3,   1.,  648.,    NA,   NA,   1., 1 ),
    'B1'   = list( 2,   0.,   99.,    NA,   NA,   1., 1 ),
    'DCK'  = list( 3,   0.,  999.,    NA,   NA,   1., 1 ),
    'SID'  = list( 3,   0.,  999.,    NA,   NA,   1., 1 ),
    'PT'   = list( 2,   0.,   21.,    NA,   NA,   1., 1 ),
    'DUPS' = list( 2,   0.,   14.,    NA,   NA,   1., 1 ),
    'DUPC' = list( 1,   0.,    2.,    NA,   NA,   1., 1 ),
    'TC'   = list( 1,   0.,    1.,    NA,   NA,   1., 1 ),
    'PB'   = list( 1,   0.,    2.,    NA,   NA,   1., 1 ),
    'WX'   = list( 1,   1.,    1.,    NA,   NA,   1., 1 ),
    'SX'   = list( 1,   1.,    1.,    NA,   NA,   1., 1 ),
    'C2'   = list( 2,   0.,   40.,    NA,   NA,   1., 1 ),
    'SQZ'  = list( 1,   1.,   35.,    NA,   NA,   1., 2 ),
    'SQA'  = list( 1,   1.,   21.,    NA,   NA,   1., 2 ),
    'AQZ'  = list( 1,   1.,   35.,    NA,   NA,   1., 2 ),
    'AQA'  = list( 1,   1.,   21.,    NA,   NA,   1., 2 ),
    'UQZ'  = list( 1,   1.,   35.,    NA,   NA,   1., 2 ),
    'UQA'  = list( 1,   1.,   21.,    NA,   NA,   1., 2 ),
    'VQZ'  = list( 1,   1.,   35.,    NA,   NA,   1., 2 ),
    'VQA'  = list( 1,   1.,   21.,    NA,   NA,   1., 2 ),
    'PQZ'  = list( 1,   1.,   35.,    NA,   NA,   1., 2 ),
    'PQA'  = list( 1,   1.,   21.,    NA,   NA,   1., 2 ),
    'DQZ'  = list( 1,   1.,   35.,    NA,   NA,   1., 2 ),
    'DQA'  = list( 1,   1.,   21.,    NA,   NA,   1., 2 ),
    'ND'   = list( 1,   1.,   2.,     NA,   NA,   1., 1 ),
    'SF'   = list( 1,   1.,   15.,    NA,   NA,   1., 2 ),
    'AF'   = list( 1,   1.,   15.,    NA,   NA,   1., 2 ),
    'UF'   = list( 1,   1.,   15.,    NA,   NA,   1., 2 ),
    'VF'   = list( 1,   1.,   15.,    NA,   NA,   1., 2 ),
    'PF'   = list( 1,   1.,   15.,    NA,   NA,   1., 2 ),
    'RF'   = list( 1,   1.,   15.,    NA,   NA,   1., 2 ),
    'ZNC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'WNC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'BNC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'XNC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'YNC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'PNC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'ANC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'GNC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'DNC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'SNC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'CNC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'ENC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'FNC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'TNC'  = list( 1,   1.,   10.,    NA,   NA,   1., 2 ),
    'QCE'  = list( 2,   0.,   63.,    NA,   NA,   1., 1 ),
    'LZ'   = list( 1,   1.,    1.,    NA,   NA,   1., 1 ),
    'QCZ'  = list( 2,   0.,   31.,    NA,   NA,   1., 1 )
)

# Attachments 2, 3 & 4 are deprecated - still here, but in a seperate section below.

# IMMT5 attachment
attachments[5] = 'C5' # 'IMMT-5/FM 13'
definitions[['C5']] = list(
    'OS'    = list( 1,   0.,       6.,     NA,    NA,  1.,  1 ),
    'OP'    = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'FM'    = list( 1,   0.,      36.,     NA,    NA,  1.,  2 ),
    'IMMV'  = list( 1,   0.,      36.,     NA,    NA,  1.,  2 ),
    'IX'    = list( 1,   1.,       7.,     NA,    NA,  1.,  1 ),
    'W2'    = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'WMI'   = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'SD2'   = list( 2,   0.,      38.,     NA,    NA,  1.,  1 ),
    'SP2'   = list( 2,   0.,      30.,     0.,   99.,  1.,  1 ),
    'SH2'   = list( 2,   0.,      99.,     NA,    NA,  1.,  1 ),
    'IS'    = list( 1,   1.,       5.,     NA,    NA,  1.,  1 ),
    'ES'    = list( 2,   0.,      99.,     NA,    NA,  1.,  1 ),
    'RS'    = list( 1,   0.,       4.,     NA,    NA,  1.,  1 ),
    'IC1'   = list( 1,   0.,      10.,     NA,    NA,  1.,  2 ),
    'IC2'   = list( 1,   0.,      10.,     NA,    NA,  1.,  2 ),
    'IC3'   = list( 1,   0.,      10.,     NA,    NA,  1.,  2 ),
    'IC4'   = list( 1,   0.,      10.,     NA,    NA,  1.,  2 ),
    'IC5'   = list( 1,   0.,      10.,     NA,    NA,  1.,  2 ),
    'IR'    = list( 1,   0.,       4.,     NA,    NA,  1.,  1 ),
    'RRR'   = list( 3,   0.,     999.,     NA,    NA,  1.,  1 ),
    'TR'    = list( 1,   1.,       9.,     NA,    NA,  1.,  1 ),
    'NU'    = list( 1,   NA,       NA,     NA,    NA,  1.,  3 ),
    'QCI'   = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI1'   = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI2'   = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI3'   = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI4'   = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI5'   = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI6'   = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI7'   = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI8'   = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI9'   = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI10'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI11'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI12'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI13'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI14'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI15'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI16'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI17'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI18'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI19'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI20'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI21'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'HDG'   = list( 3,   0.,     360.,     NA,    NA,  1.,  1 ),
    'COG'   = list( 3,   0.,     360.,     NA,    NA,  1.,  1 ),
    'SOG'   = list( 2,   0.,      99.,     NA,    NA,  1.,  1 ),
    'SLL'   = list( 2,   0.,      99.,     NA,    NA,  1.,  1 ),
    'SLHH'  = list( 3, -99.,      99.,     NA,    NA,  1.,  1 ),
    'RWD'   = list( 3,   1.,     362.,     NA,    NA,  1.,  1 ),
    'RWS'   = list( 3,  0.0,     99.9,     NA,    NA,  0.1, 1 ),
    'QI22'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI23'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI24'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI25'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI26'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI27'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI28'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'QI29'  = list( 1,   0.,       9.,     NA,    NA,  1.,  1 ),
    'RH'    = list( 4,   0.,     100.,     NA,    NA,  0.1, 1 ),
    'RHI'   = list( 1,   0.,       4.,     NA,    NA,  1.,  1 ),
    'AWSI'  = list( 1,   0.,       2.,     NA,    NA,  1.,  1 ),
    'IMONO' = list( 7,   0., 9999999.,     NA,    NA,  1.,  1 )
)

# Model quality control attachment
attachments[6] = 'C6' # 'Model quality control'
definitions[['C6']] = list(
    'CCCC'  = list( 4,    65.,    90.,    NA,    NA,    NA,  3 ),
    'BUID'  = list( 6,    48.,    57.,   65.,   90.,    NA,  3 ),
    'FBSRC' = list( 1,     0.,     0.,    NA,    NA,    1.,  1 ),
    'BMP'   = list( 5,  870.0, 1074.6,    NA,    NA,   0.1,  1 ),
    'BSWU'  = list( 4,  -99.9,   99.9,    NA,    NA,   0.1,  1 ),
    'SWU'   = list( 4,  -99.9,   99.9,    NA,    NA,   0.1,  1 ),
    'BSWV'  = list( 4,  -99.9,   99.9,    NA,    NA,   0.1,  1 ),
    'SWV'   = list( 4,  -99.9,   99.9,    NA,    NA,   0.1,  1 ),
    'BSAT'  = list( 4,  -99.9,   99.9,    NA,    NA,   0.1,  1 ),
    'BSRH'  = list( 3,     0.,   100.,    NA,    NA,    1.,  1 ),
    'SRH'   = list( 3 ,    0.,   100.,    NA,    NA,    1.,  1 ),
    'BSST'  = list( 5, -99.99,  99.99,    NA,    NA,  0.01,  1 ),
    'MST'   = list( 1,     0.,     9.,    NA,    NA,    1.,  1 ),
    'MSH'   = list( 4,  -999.,  9999.,    NA,    NA,    1.,  1 ),
    'BY'    = list( 4,     0.,  9999.,    NA,    NA,    1.,  1 ),
    'BM'    = list( 2,     1.,    12.,    NA,    NA,    1.,  1 ),
    'BD'    = list( 2,     1.,    31.,    NA,    NA,    1.,  1 ),
    'BH'    = list( 2,     0.,    23.,    NA,    NA,    1.,  1 ),
    'BFL'   = list( 2,     0.,    99.,    NA,    NA,    1.,  1 )
)

# Ship metadata attachment
attachments[7] = 'C7' # 'Ship metadata'
definitions[['C7']] = list(
    'MDS' = list( 1,    0.,      1.,    NA,    NA,    1.,  1 ),
    'C1M' = list( 2,    NA,      NA,    NA,    NA,    NA,  3 ),
    'OPM' = list( 2,    0.,     99.,    NA,    NA,    1.,  1 ),
    'KOV' = list( 2,    NA,      NA,    NA,    NA,    NA,  3 ),
    'COR' = list( 2,    NA,      NA,    NA,    NA,    NA,  3 ),
    'TOB' = list( 3,    NA,      NA,    NA,    NA,    NA,  3 ),
    'TOT' = list( 3,    NA,      NA,    NA,    NA,    NA,  3 ),
    'EOT' = list( 2,    NA,      NA,    NA,    NA,    NA,  3 ),
    'LOT' = list( 2,    NA,      NA,    NA,    NA,    NA,  3 ),
    'TOH' = list( 1,    NA,      NA,    NA,    NA,    NA,  3 ),
    'EOH' = list( 2,    NA,      NA,    NA,    NA,    NA,  3 ),
    'SIM' = list( 3,    NA,      NA,    NA,    NA,    NA,  3 ),
    'LOV' = list( 3,    0.,    999.,    NA,    NA,    1.,  1 ),
    'DOS' = list( 2,    0.,     99.,    NA,    NA,    1.,  1 ),
    'HOP' = list( 3,    0.,    999.,    NA,    NA,    1.,  1 ),
    'HOT' = list( 3,    0.,    999.,    NA,    NA,    1.,  1 ),
    'HOB' = list( 3,    0.,    999.,    NA,    NA,    1.,  1 ),
    'HOA' = list( 3,    0.,    999.,    NA,    NA,    1.,  1 ),
    'SMF' = list( 5,    0.,  99999.,    NA,    NA,    1.,  1 ),
    'SME' = list( 5,    0.,  99999.,    NA,    NA,    1.,  1 ),
    'SMV' = list( 2,    0.,     99.,    NA,    NA,    1.,  1 )
)
# Near-surface oceanographic data attachment
attachments[8] = 'C8' # 'NOCN'
definitions[['C8']] = list(
    'OTV'  = list(  5,  -3.,  38.999,    NA,    NA,  0.001,  1 ),
    'OTZ'  = list(  4,   0.,   99.99,    NA,    NA,   0.01,  1 ),
    'OSV'  = list(  5,   0.,  40.999,    NA,    NA,  0.001,  1 ),
    'OSZ'  = list(  4,   0.,   99.99,    NA,    NA,   0.01,  1 ),
    'OOV'  = list(  4,   0.,   12.99,    NA,    NA,   0.01,  1 ),
    'OOZ'  = list(  4,   0.,   99.99,    NA,    NA,   0.01,  1 ),
    'OPV'  = list(  4,   0.,   30.99,    NA,    NA,   0.01,  1 ),
    'OPZ'  = list(  4,   0.,   99.99,    NA,    NA,   0.01,  1 ),
    'OSIV' = list(  5,   0.,  250.99,    NA,    NA,   0.01,  1 ),
    'OSIZ' = list(  4,   0.,   99.99,    NA,    NA,   0.01,  1 ),
    'ONV'  = list(  5,   0.,  500.99,    NA,    NA,   0.01,  1 ),
    'ONZ'  = list(  4,   0.,   99.99,    NA,    NA,   0.01,  1 ),
    'OPHV' = list(  3,  6.2,     9.2,    NA,    NA,   0.01,  1 ),
    'OPHZ' = list(  4,   0.,   99.99,    NA,    NA,   0.01,  1 ),
    'OCV'  = list(  4,   0.,   50.99,    NA,    NA,   0.01,  1 ),
    'OCZ'  = list(  4,   0.,   99.99,    NA,    NA,   0.01,  1 ),
    'OAV'  = list(  3,   0.,     3.1,    NA,    NA,   0.01,  1 ),
    'OAZ'  = list(  4,   0.,   99.99,    NA,    NA,   0.01,  1 ),
    'OPCV' = list(  4,   0.,    999.,    NA,    NA,    0.1,  1 ),
    'OPCZ' = list(  4,   0.,   99.99,    NA,    NA,   0.01,  1 ),
    'ODV'  = list(  2,   0.,      4.,    NA,    NA,    0.1,  1 ),
    'ODZ'  = list(  4,   0.,   99.99,    NA,    NA,   0.01,  1 ),
    'PUID' = list( 10,   NA,      NA,    NA,    NA,     NA,  3 )
)
# Edited cloud report attachment
attachments[9] = 'C9' # 'Ecr'
definitions[['C9']] = list(
    'CCe' = list( 1,   0.,  13.,    NA,    NA,    1.,  2 ),
    'WWe' = list( 2,   0.,  99.,    NA,    NA,    1.,  1 ),
    'Ne'  = list( 1,   0.,   8.,    NA,    NA,    1.,  1 ),
    'NHe' = list( 1,   0.,   8.,    NA,    NA,    1.,  1 ),
    'He'  = list( 1,   0.,   9.,    NA,    NA,    1.,  1 ),
    'CLe' = list( 2,   0.,  11.,    NA,    NA,    1.,  1 ),
    'CMe' = list( 2,   0.,  12.,    NA,    NA,    1.,  1 ),
    'CHe' = list( 1,   0.,   9.,    NA,    NA,    1.,  1 ),
    'AM'  = list( 3,   0.,   8.,    NA,    NA,  0.01,  1 ),
    'AH'  = list( 3,   0.,   8.,    NA,    NA,  0.01,  1 ),
    'UM'  = list( 1,   0.,   8.,    NA,    NA,    1.,  1 ),
    'UH'  = list( 1,   0.,   8.,    NA,    NA,    1.,  1 ),
    'SBI' = list( 1,   0.,    1,    NA,    NA,    1.,  1 ),
    'SA'  = list( 4,  -90,   90,    NA,    NA,   0.1,  1 ),
    'RI'  = list( 4, -1.1, 1.17,    NA,    NA,  0.01,  1 )
)
# Reanalysis QC/Feedback attachment
attachments[95] = 'C95' # 'Rean-qc'
definitions[['C95']] = list(
    'ICNR'  = list( 2,       0.,      99.,    NA,    NA,     1,  1 ),
    'FNR'   = list( 2,       1.,      99.,    NA,    NA,     1,  1 ),
    'DPRO'  = list( 2,       1.,      99.,    NA,    NA,     1,  1 ),
    'DPRP'  = list( 2,       1.,      99.,    NA,    NA,     1,  1 ),
    'UFR'   = list( 1,       1.,       6.,    NA,    NA,     1,  1 ),
    'MFGR'  = list( 7, -999999.,  999999.,    NA,    NA,     1,  1 ), # Scaling inherited from
    'MFGSR' = list( 7, -999999.,  999999.,    NA,    NA,     1,  1 ), # variable selected
    'MAR'   = list( 7, -999999.,  999999.,    NA,    NA,     1,  1 ),  # by ICNR & FNR
    'MASR'  = list( 7, -999999.,  999999.,    NA,    NA,     1,  1 ),
    'BCR'   = list( 7, -999999.,  999999.,    NA,    NA,     1,  1 ),
    'ARCR'  = list( 4,       NA,       NA,    NA,    NA,    NA,  3 ),
    'CDR'   = list( 8, 20140101, 29991231,    NA,    NA,     1,  1 ), # ISO 8601 date
    'ASIR'  = list( 1,        0,        1,    NA,    NA,     1,  1 )
)                  
# ICOADS Value-Added Database attachment
attachments[96] = 'C95' # 'IVAD'
definitions[['C96']] = list(
    'ICNI'  = list( 2,        0.,       99.,    NA,    NA,    1.,  1 ),
    'FNI'   = list( 2,        1.,       99.,    NA,    NA,    1.,  1 ),
    'JVAD'  = list( 1,        0.,       36.,    NA,    NA,    1.,  2 ),
    'VAD'   = list( 6,   -99999.,   999999.,    NA,    NA,    1.,  1 ), # Scaling inherited from
    'IVAU1' = list( 1,        1.,       36.,    NA,    NA,    1.,  2 ),
    'JVAU1' = list( 1,        0.,       36.,    NA,    NA,    1.,  2 ),
    'VAU1'  = list( 6,   -99999.,   999999.,    NA,    NA,    1.,  1 ), # variable selected
    'IVAU2' = list( 1,        1,        36.,    NA,    NA,    1.,  2 ),
    'JVAU2' = list( 1,        0.,       36.,    NA,    NA,    1.,  2 ),
    'VAU2'  = list( 6,   -99999.,   999999.,    NA,    NA,    1.,  1 ), # by ICNI & FNI
    'IVAU3' = list( 1,        1.,       36.,    NA,    NA,    1.,  2 ),
    'JVAU3' = list( 1,        0.,       36.,    NA,    NA,    1.,  2 ),
    'VAU3'  = list( 6,   -99999.,   999999.,    NA,    NA,    1.,  1 ),
    'VQC'   = list( 1,        1.,        9.,    NA,    NA,    1.,  1 ),
    'ARCI'  = list( 4,        NA,        NA,    NA,    NA,    NA,  3 ),
    'CDR'   = list( 8, 20140101., 29991231.,    NA,    NA,    1.,  1 ), # ISO 8601 date
    'ASII'  = list( 1,        0.,        1.,    NA,    NA,    1.,  1 )
)                  
# Error attachment
attachments[97] = 'C97' # 'Error'
definitions[['C97']] = list(
     'ICNE' = list(    2,        0.,       99.,    NA,    NA,    1.,  1 ),
     'FNE'  = list(    2,        1.,       99.,    NA,    NA,    1.,  1 ),
     'CEF'  = list(    1,        0.,        1.,    NA,    NA,    1.,  1 ),
     'ERRD' = list(   NA,        NA,        NA,    NA,    NA,    NA,  1 ), # Inherited from ICNE and FNE
     'ARCE' = list(    4,        NA,        NA,    NA,    NA,    NA,  3 ),
     'CDE'  = list(    8, 20140101., 29991231.,    NA,    NA,    1.,  1 ), # ISO 8601 date
     'ASIE' = list(    1,        0.,        1.,    NA,    NA,    1.,  1 )
)   
# Unique report attachment
attachments[98] = 'C98' # 'Uida'
definitions[['C98']] = list(
     'UID' = list( 6,    NA,    NA,    NA,    NA,    NA,  3 ),
     'RN1' = list( 1,     0,    36,    NA,    NA,    1.,  2 ),
     'RN2' = list( 1,     0,    36,    NA,    NA,    1.,  2 ),
     'RN3' = list( 1,     0,    36,    NA,    NA,    1.,  2 ),
     'RSA' = list( 1,     0,     2,    NA,    NA,    1.,  1 ),
     'IRF' = list( 1,     0,     1,    NA,    NA,    1.,  1 )
)                 
# Supplemental attachment
attachments[99] = 'C99'  # 'supplemental'
definitions[['C99']] = list(
    'SUPD' = list(   NA,    NA,    NA,    NA,    NA,    NA,  3 )
)

# Deprecated attachments

# IMMT2 attachment - deprecated
attachments[2] = 'C2' # 'IMMT-2/FM 13 (deprecated)'
definitions[['C2']] = list(
    'OS'   = list( 1, 0.,   6.,     NA,    NA,  1.,  1 ),
    'OP'   = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'FM'   = list( 2, 0.,   8.,     NA,    NA,  1.,  1 ),
    'IX'   = list( 1, 1.,   7.,     NA,    NA,  1.,  1 ),
    'W2'   = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'SGN'  = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'SGT'  = list( 1, 0.,   10.,    NA,    NA,  1.,  2 ),
    'SGH'  = list( 2, 0.,   50.,  56.,   99.,   1.,  1 ),
    'WMI'  = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'SD2'  = list( 2, 0.,   38.,    NA,    NA,  1.,  1 ),
    'SP2'  = list( 2, 0.,   30.,  99.,   99.,   1.,  1 ),
    'SH2'  = list( 2, 0.,   99.,    NA,    NA,  1.,  1 ),
    'IS'   = list( 1, 1.,   5.,     NA,    NA,  1.,  1 ),
    'ES'   = list( 2, 0.,   99.,    NA,    NA,  1.,  1 ),
    'RS'   = list( 1, 0.,   4.,     NA,    NA,  1.,  1 ),
    'IC1'  = list( 1, 0.,   10.,    NA,    NA,  1.,  2 ),
    'IC2'  = list( 1, 0.,   10.,    NA,    NA,  1.,  2 ),
    'IC3'  = list( 1, 0.,   10.,    NA,    NA,  1.,  2 ),
    'IC4'  = list( 1, 0.,   10.,    NA,    NA,  1.,  2 ),
    'IC5'  = list( 1, 0.,   10.,    NA,    NA,  1.,  2 ),
    'IR'   = list( 1, 0.,   4.,     NA,    NA,  1.,  1 ),
    'RRR'  = list( 3, 0.,   999.,   NA,    NA,  1.,  1 ),
    'TR'   = list( 1, 1.,   9.,     NA,    NA,  1.,  1 ),
    'QCI'  = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI1'  = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI2'  = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI3'  = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI4'  = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI5'  = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI6'  = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI7'  = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI8'  = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI9'  = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI10' = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI11' = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI12' = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI13' = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI14' = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI15' = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI16' = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI17' = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI18' = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI19' = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI20' = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'QI21' = list( 1, 0.,   9.,     NA,    NA,  1.,  1 ),
    'HDG'  = list( 3, 0.,   360.,   NA,    NA,  1.,  1 ),
    'COG'  = list( 3, 0.,   360.,   NA,    NA,  1.,  1 ),
    'SOG'  = list( 2, 0.,   99.,    NA,    NA,  1.,  1 ),
    'SLL'  = list( 2, 0.,   99.,    NA,    NA,  1.,  1 ),
    'SLHH' = list( 3, -99., 99.,    NA,    NA,  1.,  1 ),
    'RWD'  = list( 3, 1.,   362.,   NA,    NA,  1.,  1 ),
    'RWS'  = list( 3, 0.0,  99.9,   NA,    NA,  0.1, 1 )
)
# Model quality control attachment - deprecated
attachments[3] = 'C3' # 'Model quality control (deprecated)';
definitions[['C3']] = list(
    'CCCC' = list( 4, 65.,   90.,      NA,    NA,    NA,  3 ),
    'BUID' = list( 6, 48.,   57.,    65.,   90.,     NA,  3 ),
    'BMP'  = list( 5, 870.0, 1074.6,   NA,    NA,  0.1,   1 ),
    'BSWU' = list( 4, -99.9, 99.9,     NA,    NA,  0.1,   1 ),
    'SWU'  = list( 4, -99.9, 99.9,     NA,    NA,  0.1,   1 ),
    'BSWV' = list( 4, -99.9, 99.9,     NA,    NA,  0.1,   1 ),
    'SWV'  = list( 4, -99.9, 99.9,     NA,    NA,  0.1,   1 ),
    'BSAT' = list( 4, -99.9, 99.9,     NA,    NA,  0.1,   1 ),
    'BSRH' = list( 3, 0.,    100.,     NA,    NA,  1.,    1 ),
    'SRH'  = list( 3, 0.,    100.,     NA,    NA,  1.,    1 ),
    'SIX'  = list( 1, 2.,    3.,       NA,    NA,  1.,    1 ),
    'BSST' = list( 4, -99.9, 99.9,     NA,    NA,  0.1,   1 ),
    'MST'  = list( 1, 0.,    9.,       NA,    NA,  1.,    1 ),
    'MSH'  = list( 3, 0.,    999.,     NA,    NA,  1.,    1 ),
    'BY'   = list( 4, 0.,    9999.,    NA,    NA,  1.,    1 ),
    'BM'   = list( 2, 1.,    12.,      NA,    NA,  1.,    1 ),
    'BD'   = list( 2, 1.,    31.,      NA,    NA,  1.,    1 ),
    'BH'   = list( 2, 0.,    23.,      NA,    NA,  1.,    1 ),
    'BFL'  = list( 2, 0.,    99.,      NA,    NA,  1.,    1 )
)
# Ship Metadata attachment - deprecated
attachments[4] = 'C4' # 'Ship metadata (deprecated)'
definitions[['C4']] = list(
    'C1M' = list( 2, 65., 90.,      NA,    NA,  NA,  3 ),
    'OPM' = list( 2, 0.,  99.,      NA,    NA,  1.,  1 ),
    'KOV' = list( 2, 32., 126.,     NA,    NA,  NA,  3 ),
    'COR' = list( 2, 65., 90.,      NA,    NA,  NA,  3 ),
    'TOB' = list( 3, 32., 126.,     NA,    NA,  NA,  3 ),
    'TOT' = list( 3, 32., 126.,     NA,    NA,  NA,  3 ),
    'EOT' = list( 2, 32., 126.,     NA,    NA,  NA,  3 ),
    'LOT' = list( 2, 32., 126.,     NA,    NA,  NA,  3 ),
    'TOH' = list( 1, 32., 126.,     NA,    NA,  NA,  3 ),
    'EOH' = list( 2, 32., 126.,     NA,    NA,  NA,  3 ),
    'SIM' = list( 3, 32., 126.,     NA,    NA,  NA,  3 ),
    'LOV' = list( 3, 0.,  999.,     NA,    NA,  1.,  1 ),
    'DOS' = list( 2, 0.,  99.,      NA,    NA,  1.,  1 ),
    'HOP' = list( 3, 0.,  999.,     NA,    NA,  1.,  1 ),
    'HOT' = list( 3, 0.,  999.,     NA,    NA,  1.,  1 ),
    'HOB' = list( 3, 0.,  999.,     NA,    NA,  1.,  1 ),
    'HOA' = list( 3, 0.,  999.,     NA,    NA,  1.,  1 ),
    'SMF' = list( 5, 0.,  99999.,   NA,    NA,  1.,  1 ),
    'SME' = list( 5, 0.,  99999.,   NA,    NA,  1.,  1 ),
    'SMV' = list( 2, 0.,  99.,      NA,    NA,  1.,  1 )
)


