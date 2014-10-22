// Define a class for parsing and processing IMMA records
//  (Essentially translated from the Perl module).

// Constructor
function IMMA(sr) {  // sr is the string representation of the record
	this.string = sr;
	this.attachments = new Array();
	this.unpackString();
}

// Return string representation of record
IMMA.prototype.toString = function() {
	return this.string;
}

// Clear any unpacked instance variables
IMMA.prototype.clear = function() {
	for(var i in this) { 
		if(this.hasOwnProperty(i)) {
			if(i=='string') { continue; } // don't delete the string representation
			this[i] = null;
		}
    }
	this.attachments = new Array();
}

// Extract the named parameters fron the string version of an attachment
IMMA.prototype.decodeAttachment = function(as_string,attachment,parameters,definitions) {
    // as_string   - String representation of the attachment
    // attachment  - Attachment name
    // parameters  - Attachment parameter array
    // definitions - Attachment definitions hash
    if(!as_string) {
        throw new Error("No data to decode");
    }
    var Position = 0;
    for ( var i = 0 ; i < parameters.length ; i++ ) {
        if ( definitions[parameters[i]][0]!=null ) {
            this[parameters[i]] =
              as_string.slice( Position,
                Position+definitions[parameters[i]][0] );
            Position += definitions[parameters[i]][0];
        }
        else {                  // undefined length - so slurp all the data
            this[parameters[i]] =
              as_string.slice(Position, as_string.length);
            //chomp(this[parameters[i]]);
            Position = as_string.length;
        }

        // Nothing but blanks means value is null
		if(this[parameters[i]].search(/\S/)==-1) {
            this[parameters[i]] = null;
            continue;
        }
        if ( definitions[parameters[i]][6] == 2 ) {
            this[parameters[i]] =
              IMMA.decode_base36( this[parameters[i]] );
        }
        if ( definitions[parameters[i]][5] ) {
            this[parameters[i]] *=
              definitions[parameters[i]][5];
        }
		// Don't bother with the check in this version
    }
}

// Extract and populate the instance variables from the string representation
IMMA.prototype.unpackString = function() {
    
    // Core is always present (and first)
    var Attachment = 0;
    var Length     = 108;

    // Decode each attachment
	var line = this.string;
    while ( line.length > 0 ) {

        // Pad the string with blanks if it's too short
        if (Length
            && Length > 0
            && line.length < Length )
        {
		    for(var i = 0; i<Length ; i++) { line += " "; }

        }
        this.decodeAttachment(
            line,
            IMMA.attachments[Attachment],
            IMMA.parameters[Attachment],
            IMMA.definitions[Attachment]
        );
        this.attachments.push(Attachment);
        if ( Length==null || Length == 0 ) {
            break;
        }
        line = line.substr( Length );
        if ( line.length > 0 ) {
            Attachment = parseInt(line.substr( 0, 2 ));
            if(isNaN(Attachment)) { 
                line="";
                break;
            }
            Length     = line.substr( 2, 2 );
            if ( Length.search(/\S/)<0 ) { Length = null; }
            if ( Length && Length != 0 ) {
                Length -= 4;
            }
            line = line.substr( 4 );
            if ( IMMA.attachments[Attachment]==null ) {
                throw new Error("Unsupported attachment ID "+Attachment);
            }
        }
    }
    return 1;
}

// Make the string version from the instance variables 
IMMA.prototype.packString = function() {

    this.string = "";
    for(var Attachment in this.attachments) {
        this.string += this.encodeAttachment(
            this.attachments[Attachment],
            IMMA.parameters[this.attachments[Attachment]],
            IMMA.definitions[this.attachments[Attachment]]
        );
    }
    return 1;
}

// Make a string representation of an attachment
IMMA.prototype.encodeAttachment = function(attachment,parameters,definitions){

    var Result = "";
    for ( var i = 0 ; i < parameters.length ; i++ ) {
        if ( this[parameters[i]]!=null 
            && this.checkParameter( parameters[i], definitions ) )
        {
            var Tmp = this[parameters[i]];

            // Scale to integer units for output
            if ( definitions[parameters[i]][5] != null ) {
                Tmp /= definitions[parameters[i]][5];
                Tmp = parseInt(Tmp);
            }

            // Encode as base36 if required
            if ( definitions[parameters[i]][5] == 2 ) {
                Tmp = IMMA.encode_base36(Tmp);
            }

            // Convert to a string of the correct length
            if ( definitions[parameters[i]][6] == 1 ) {

                // Integer
                if ( definitions[parameters[i]][0] != null ) {
                    Tmp=Tmp.toString();
                    while(Tmp.length<definitions[parameters[i]][0]) {
                        Tmp=" "+Tmp;
                    }
                }
                else {

                    // Undefined length - should never happen
                    Tmp=Tmp.toString();
                }
            }
            else {

                // String
                if ( definitions[parameters[i]][0] != null ) {
                    Tmp=Tmp.toString();
                    while(Tmp.length<definitions[parameters[i]][0]) {
                        Tmp=Tmp+" ";
                    }
                }
                else {
                
                   // Undefined length - only for supplementary data
                   Tmp=Tmp.toString(); 
                }
            }
            Result += Tmp;

        }
        else {

            // Undefined data - make a blank string of the corect length
            if ( definitions[parameters[i]][0] != null ) {
                for(var j=0;j<definitions[parameters[i]][0];j++) {
                    Result += " ";
                }
            }
            else {

                // Undefined data with unknown length - treat as blank string
                Result += " ";
            }
        }
    }
    
    // Done all the parameters, add the ID and length to the start
    // (except for core)
    if ( attachment != 0 ) {
        if ( attachment == 99 ) {
            Result = " 0"+Result;
        }
        else {
            var Tmp = (Result.length+4).toString();
            if(Tmp.length<2) { Tmp = " "+Tmp; }
            Result = Tmp+Result;
        }
        Tmp = attachment.toString();
        if(Tmp.length<2) { Tmp= " "+Tmp; }
        Result = Tmp+Result;
    }

    return Result;
}

// Check the value for a parameter is inside its acceptable range(s)
// second input is optional - 
IMMA.prototype.checkParameter = function(parameter,definitions) {

   // Use with or without definitions array
    if(definitions==null) {
        definitions=IMMA.definitionsFor(parameter);
    }

   // Bail out if undefined or missing parameter
    if ( definitions[parameter]==null ) {
        throw new Error("No parameter "+parameter+" in IMMA.");
    }
    if ( this[parameter]==null ) { return null ; }
    
   // Character data can be anything
    if ( definitions[parameter][6] == 3 ) {
        return 1; 
    }
    if (
        (
            definitions[parameter][1] == null
            || definitions[parameter][1] <= this[parameter]
        )
        && ( definitions[parameter][2] == null
            || definitions[parameter][2] >= this[parameter] )
      )
    {
        return 1;
    }
    else if (
        (
            definitions[parameter][3] != null
            && definitions[parameter][3] <= this[parameter]
        )
        && ( definitions[parameter][4] != null
            && definitions[parameter][4] >= this[parameter] )
      )
    {
        return 1;
    }
    else {
        return null;    // Doesn't match either range
    }
}

// Base36 encoding

IMMA.decode_base36 = function(s) {
    if(!s) return 0;
	s=s.toUpperCase();
	if(s.search(/[^0-9A-Z]/)>=0) {
//		throw new Error("Function decode_base36 called with a non-alphanumeric string \""+s+"\"");
        return 0; // Fail silently for the moment
	}
    var t = 0;
	for(var i=0;i<s.length;i++) {
		t += 36*(s.length-i)+"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".indexOf(s.charAt(i));
    }
    return t;
}

IMMA.encode_base36 = function(n,p) {
    if(!p) p = 0;  // Optional argument
	if(!n.toString().search(/^-?[^0-9]+$/)>=0) {
    	throw new Error("Function encode_base36 called with non-nunmeric value for n");
	}
	if(n==0) return 0;
	if(!p.toString().search(/^-?[^0-9]+$/)) {
    	throw new Error("Function encode_base36 called with non-nunmeric value for p");
	}
    var s = "";
    while (n>0) {
		s = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".charAt(n%36)+s;
        n = Math.floor(n/36);
    }	
	while (s.length<p) s= "0"+s; // pad with '0' to specified length
    return s;
}

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

// Definitions of the attachments
IMMA.attachments  = new Array();
IMMA.parameters  = new Array();
IMMA.definitions = new Array();

// Core section
IMMA.attachments[0] = 'core';

// List of parameters in core section
// In the order they are in on disc
IMMA.parameters[0] = ['YR','MO','DY','HR','LAT','LON','IM','ATTC',
                      'TI','LI','DS','VS','NID','II','ID','C1',
					  'DI','D','WI','W','VI','VV','WW','W1',
                      'SLP','A','PPP','IT','AT','WBTI','WBT',
					  'DPTI','DPT','SI','SST','N','NH','CL',
					  'HI','H','CM','CH','WD','WP','WH','SD',
					  'SP','SH'];

// For each parameter, provide an array specifying:
//    Its length in bytes, on disc,
//    Its minimum valueIMMA::definitions[0] = {

//    Its maximum value
//    Its minimum value (alternative representation)
//    Its maximum value (alternative representation)
//    Its units scale
//    Its encoding (1 = integer, 3= character, 2= base36)
IMMA.definitions[0] = {
    YR   : [ 4, 1600.,  2024.,  null,    null,   1.,    1 ],
    MO   : [ 2, 1.,     12.,    null,    null,   1.,    1 ],
    DY   : [ 2, 1.,     31.,    null,    null,   1.,    1 ],
    HR   : [ 4, 0.00,   23.99,  null,    null,   0.01,  1 ],
    LAT  : [ 5, -90.00, 90.00,  null,    null,   0.01,  1 ],
    LON  : [ 6, 0.00,   359.99, -179.99, 180.00, 0.01,  1 ],
    IM   : [ 2, 0.,     99.,    null,    null,   1.,    1 ],
    ATTC : [ 1, 0.,     9.,     null,    null,   1.,    1 ],
    TI   : [ 1, 0.,     3.,     null,    null,   1.,    1 ],
    LI   : [ 1, 0.,     6.,     null,    null,   1.,    1 ],
    DS   : [ 1, 0.,     9.,     null,    null,   1.,    1 ],
    VS   : [ 1, 0.,     9.,     null,    null,   1.,    1 ],
    NID  : [ 2, 0.,     99.,    null,    null,   1.,    1 ],
    II   : [ 2, 0.,     10.,    null,    null,   1.,    1 ],
    ID   : [ 9, 32.,    126.,   null,    null,   null,  3 ],
    C1   : [ 2, 48.,    57.,    65.,     90.,    null,  3 ],
    DI   : [ 1, 0.,     6.,     null,    null,   1.,    1 ],
    D    : [ 3, 1.,     362.,   null,    null,   1.,    1 ],
    WI   : [ 1, 0.,     8.,     null,    null,   1.,    1 ],
    W    : [ 3, 0.0,    99.9,   null,    null,   0.1,   1 ],
    VI   : [ 1, 0.,     2.,     null,    null,   1.,    1 ],
    VV   : [ 2, 90.,    99.,    null,    null,   1.,    1 ],
    WW   : [ 2, 0.,     99.,    null,    null,   1.,    1 ],
    W1   : [ 1, 0.,     9.,     null,    null,   1.,    1 ],
    SLP  : [ 5, 870.0,  1074.6, null,    null,   0.1,   1 ],
    A    : [ 1, 0.,     8.,     null,    null,   1.,    1 ],
    PPP  : [ 3, 0.0,    51.0,   null,    null,   0.1,   1 ],
    IT   : [ 1, 0.,     9.,     null,    null,   1.,    1 ],
    AT   : [ 4, -99.9,  99.9,   null,    null,   0.1,   1 ],
    WBTI : [ 1, 0.,     3.,     null,    null,   1.,    1 ],
    WBT  : [ 4, -99.9,  99.9,   null,    null,   0.1,   1 ],
    DPTI : [ 1, 0.,     3.,     null,    null,   1.,    1 ],
    DPT  : [ 4, -99.9,  99.9,   null,    null,   0.1,   1 ],
    SI   : [ 2, 0.,     12.,    null,    null,   1.,    1 ],
    SST  : [ 4, -99.9,  99.9,   null,    null,   0.1,   1 ],
    N    : [ 1, 0.,     9.,     null,    null,   1.,    1 ],
    NH   : [ 1, 0.,     9.,     null,    null,   1.,    1 ],
    CL   : [ 1, 0.,     10.,    null,    null,   1.,    2 ],
    HI   : [ 1, 0.,     1.,     null,    null,   1.,    1 ],
    H    : [ 1, 0.,     10.,    null,    null,   1.,    2 ],
    CM   : [ 1, 0.,     10.,    null,    null,   1.,    2 ],
    CH   : [ 1, 0.,     10.,    null,    null,   1.,    2 ],
    WD   : [ 2, 0.,     38.,    null,    null,   1.,    1 ],
    WP   : [ 2, 0.,     30.,    99.,     99.,    1.,    1 ],
    WH   : [ 2, 0.,     99.,    null,    null,   1.,    1 ],
    SD   : [ 2, 0.,     38.,    null,    null,   1.,    1 ],
    SP   : [ 2, 0.,     30.,    99.,     99.,    1.,    1 ],
    SH   : [ 2, 0.,     99.,    null,    null,   1.,    1 ]
};

//ICOADS attachment
IMMA.attachments[1] = 'icoads';
IMMA.parameters[1]  = ['BSI','B10','B1','DCK','SID','PT',
                       'DUPS','DUPC','TC','PB','WX','SX',
					   'C2','SQZ','SQA','AQZ','AQA','UQZ',
					   'UQA','VQZ','VQA','PQZ','PQA','DQZ',
					   'DQA','ND','SF','AF','UF','VF','PF',
					   'RF','ZNC','WNC','BNC','XNC','YNC',
					   'PNC','ANC','GNC','DNC','SNC','CNC',
					   'ENC','FNC','TNC','QCE','LZ','QCZ'];
IMMA.definitions[1] = {
    BSI  : [ 1, null,  null,  null, null, 1., 1 ],
    B10  : [ 3, 1.,    648.,  null, null, 1., 1 ],
    B1   : [ 2, 0.,    99.,   null, null, 1., 1 ],
    DCK  : [ 3, 0.,    999.,  null, null, 1., 1 ],
    SID  : [ 3, 0.,    999.,  null, null, 1., 1 ],
    PT   : [ 2, 0.,    15.,   null, null, 1., 1 ],
    DUPS : [ 2, 0.,    14.,   null, null, 1., 1 ],
    DUPC : [ 1, 0.,    2.,    null, null, 1., 1 ],
    TC   : [ 1, 0.,    1.,    null, null, 1., 1 ],
    PB   : [ 1, 0.,    2.,    null, null, 1., 1 ],
    WX   : [ 1, 1.,    1.,    null, null, 1., 1 ],
    SX   : [ 1, 1.,    1.,    null, null, 1., 1 ],
    C2   : [ 2, 0.,    40.,   null, null, 1., 1 ],
    SQZ  : [ 1, 1.,    35.,   null, null, 1., 2 ],
    SQA  : [ 1, 1.,    21.,   null, null, 1., 2 ],
    AQZ  : [ 1, 1.,    35.,   null, null, 1., 2 ],
    AQA  : [ 1, 1.,    21.,   null, null, 1., 2 ],
    UQZ  : [ 1, 1.,    35.,   null, null, 1., 2 ],
    UQA  : [ 1, 1.,    21.,   null, null, 1., 2 ],
    VQZ  : [ 1, 1.,    35.,   null, null, 1., 2 ],
    VQA  : [ 1, 1.,    21.,   null, null, 1., 2 ],
    PQZ  : [ 1, 1.,    35.,   null, null, 1., 2 ],
    PQA  : [ 1, 1.,    21.,   null, null, 1., 2 ],
    DQZ  : [ 1, 1.,    35.,   null, null, 1., 2 ],
    DQA  : [ 1, 1.,    21.,   null, null, 1., 2 ],
    ND   : [ 1, 1.,    2.,    null, null, 1., 1 ],
    SF   : [ 1, 1.,    15.,   null, null, 1., 2 ],
    AF   : [ 1, 1.,    15.,   null, null, 1., 2 ],
    UF   : [ 1, 1.,    15.,   null, null, 1., 2 ],
    VF   : [ 1, 1.,    15.,   null, null, 1., 2 ],
    PF   : [ 1, 1.,    15.,   null, null, 1., 2 ],
    RF   : [ 1, 1.,    15.,   null, null, 1., 2 ],
    ZNC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    WNC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    BNC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    XNC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    YNC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    PNC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    ANC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    GNC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    DNC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    SNC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    CNC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    ENC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    FNC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    TNC  : [ 1, 1.,    10.,   null, null, 1., 2 ],
    QCE  : [ 2, 0.,    63.,   null, null, 1., 1 ],
    LZ   : [ 1, 1.,    1.,    null, null, 1., 1 ],
    QCZ  : [ 2, 0.,    31.,   null, null, 1., 1 ]
};

// IMMT2 attachment
IMMA.attachments[2] = 'immt2';
IMMA.parameters[2]  = ['OS','OP','FM','IX','W2','SGN',
                       'SGT','SGH','WMI','SD2','SP2',
					   'SH2','IS','ES','RS','IC1','IC2',
					   'IC3','IC4','IC5','IR','RRR','TR',
					   'QCI','QI1','QI2','QI3','QI4',
					   'QI5','QI6','QI7','QI8','QI9',
					   'QI10','QI11','QI12','QI13','QI14',
					   'QI15','QI16','QI17','QI18','QI19',
					   'QI20','QI21','HDG','COG','SOG',
					   'SLL','SLHH','RWD','RWS'];
IMMA.definitions[2] = {
    OS   : [ 1, 0.,   6.,   null,  null,  1.,  1 ],
    OP   : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    FM   : [ 2, 0.,   8.,   null,  null,  1.,  1 ],
    IX   : [ 1, 1.,   7.,   null,  null,  1.,  1 ],
    W2   : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    SGN  : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    SGT  : [ 1, 0.,   10.,  null,  null,  1.,  2 ],
    SGH  : [ 2, 0.,   50.,  56.,   99.,   1.,  1 ],
    WMI  : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    SD2  : [ 2, 0.,   38.,  null,  null,  1.,  1 ],
    SP2  : [ 2, 0.,   30.,  99.,   99.,   1.,  1 ],
    SH2  : [ 2, 0.,   99.,  null,  null,  1.,  1 ],
    IS   : [ 1, 1.,   5.,   null,  null,  1.,  1 ],
    ES   : [ 2, 0.,   99.,  null,  null,  1.,  1 ],
    RS   : [ 1, 0.,   4.,   null,  null,  1.,  1 ],
    IC1  : [ 1, 0.,   10.,  null,  null,  1.,  2 ],
    IC2  : [ 1, 0.,   10.,  null,  null,  1.,  2 ],
    IC3  : [ 1, 0.,   10.,  null,  null,  1.,  2 ],
    IC4  : [ 1, 0.,   10.,  null,  null,  1.,  2 ],
    IC5  : [ 1, 0.,   10.,  null,  null,  1.,  2 ],
    IR   : [ 1, 0.,   4.,   null,  null,  1.,  1 ],
    RRR  : [ 3, 0.,   999., null,  null,  1.,  1 ],
    TR   : [ 1, 1.,   9.,   null,  null,  1.,  1 ],
    QCI  : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI1  : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI2  : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI3  : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI4  : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI5  : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI6  : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI7  : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI8  : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI9  : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI10 : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI11 : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI12 : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI13 : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI14 : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI15 : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI16 : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI17 : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI18 : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI19 : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI20 : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    QI21 : [ 1, 0.,   9.,   null,  null,  1.,  1 ],
    HDG  : [ 3, 0.,   360., null,  null,  1.,  1 ],
    COG  : [ 3, 0.,   360., null,  null,  1.,  1 ],
    SOG  : [ 2, 0.,   99.,  null,  null,  1.,  1 ],
    SLL  : [ 2, 0.,   99.,  null,  null,  1.,  1 ],
    SLHH : [ 3, -99., 99.,  null,  null,  1.,  1 ],
    RWD  : [ 3, 1.,   362., null,  null,  1.,  1 ],
    RWS  : [ 3, 0.0,  99.9, null,  null,  0.1, 1 ]
};

// Model quality control attachment
IMMA.attachments[3] = 'mqc';
IMMA.parameters[3]  = ['CCCC','BUID','BMP','BSWU','SWU',
                       'BSWV','SWV','BSAT','BSRH','SRH',
					   'SIX','BSST','MST','MSH','BY',
					   'BM','BD','BH','BFL'];
IMMA.definitions[3] = {
    CCCC : [ 4, 65.,   90.,    null,  null,  null,  3 ],
    BUID : [ 6, 48.,   57.,    65.,   90.,   null,  3 ],
    BMP  : [ 5, 870.0, 1074.6, null,  null,  0.1,   1 ],
    BSWU : [ 4, -99.9, 99.9,   null,  null,  0.1,   1 ],
    SWU  : [ 4, -99.9, 99.9,   null,  null,  0.1,   1 ],
    BSWV : [ 4, -99.9, 99.9,   null,  null,  0.1,   1 ],
    SWV  : [ 4, -99.9, 99.9,   null,  null,  0.1,   1 ],
    BSAT : [ 4, -99.9, 99.9,   null,  null,  0.1,   1 ],
    BSRH : [ 3, 0.,    100.,   null,  null,  1.,    1 ],
    SRH  : [ 3, 0.,    100.,   null,  null,  1.,    1 ],
    SIX  : [ 1, 2.,    3.,     null,  null,  1.,    1 ],
    BSST : [ 4, -99.9, 99.9,   null,  null,  0.1,   1 ],
    MST  : [ 1, 0.,    9.,     null,  null,  1.,    1 ],
    MSH  : [ 3, 0.,    999.,   null,  null,  1.,    1 ],
    BY   : [ 4, 0.,    9999.,  null,  null,  1.,    1 ],
    BM   : [ 2, 1.,    12.,    null,  null,  1.,    1 ],
    BD   : [ 2, 1.,    31.,    null,  null,  1.,    1 ],
    BH   : [ 2, 0.,    23.,    null,  null,  1.,    1 ],
    BFL  : [ 2, 0.,    99.,    null,  null,  1.,    1 ]
};

// Metadata attachment
IMMA.attachments[4] = 'metadata';
IMMA.parameters[4]  = ['C1M','OPM','KOV','COR','TOB','TOT',
                       'EOT','LOT','TOH','EOH','SIM','LOV',
					   'DOS','HOP','HOT','HOB','HOA','SMF',
					   'SME','SMV'];
IMMA.definitions[4] = {
    C1M : [ 2, 65., 90.,    null,  null,  null,  3 ],
    OPM : [ 2, 0.,  99.,    null,  null,  1.,    1 ],
    KOV : [ 2, 32., 126.,   null,  null,  null,  3 ],
    COR : [ 2, 65., 90.,    null,  null,  null,  3 ],
    TOB : [ 3, 32., 126.,   null,  null,  null,  3 ],
    TOT : [ 3, 32., 126.,   null,  null,  null,  3 ],
    EOT : [ 2, 32., 126.,   null,  null,  null,  3 ],
    LOT : [ 2, 32., 126.,   null,  null,  null,  3 ],
    TOH : [ 1, 32., 126.,   null,  null,  null,  3 ],
    EOH : [ 2, 32., 126.,   null,  null,  null,  3 ],
    SIM : [ 3, 32., 126.,   null,  null,  null,  3 ],
    LOV : [ 3, 0.,  999.,   null,  null,  1.,    1 ],
    DOS : [ 2, 0.,  99.,    null,  null,  1.,    1 ],
    HOP : [ 3, 0.,  999.,   null,  null,  1.,    1 ],
    HOT : [ 3, 0.,  999.,   null,  null,  1.,    1 ],
    HOB : [ 3, 0.,  999.,   null,  null,  1.,    1 ],
    HOA : [ 3, 0.,  999.,   null,  null,  1.,    1 ],
    SMF : [ 5, 0.,  99999., null,  null,  1.,    1 ],
    SME : [ 5, 0.,  99999., null,  null,  1.,    1 ],
    SMV : [ 2, 0.,  99.,    null,  null,  1.,    1 ]
};

// Historical attachment
IMMA.attachments[5] = 'historical';
IMMA.parameters[5]  = ['WFI','WF','XWI','XW','XDI','XD',
                       'SLPI','TAI','TA','XNI','XN'];
IMMA.definitions[5] = {
    WFI  : [ 1, null,  null,  null,  null,  null,  1 ],
    WF   : [ 2, null,  null,  null,  null,  null,  1 ],
    XWI  : [ 1, null,  null,  null,  null,  null,  1 ],
    XW   : [ 3, null,  null,  null,  null,  0.1,   1 ],
    XDI  : [ 1, null,  null,  null,  null,  null,  1 ],
    XD   : [ 2, null,  null,  null,  null,  null,  1 ],
    SLPI : [ 1, null,  null,  null,  null,  null,  1 ],
    TAI  : [ 1, null,  null,  null,  null,  null,  1 ],
    TA   : [ 4, null,  null,  null,  null,  null,  1 ],
    XNI  : [ 1, null,  null,  null,  null,  null,  1 ],
    XN   : [ 2, null,  null,  null,  null,  null,  1 ]
};

// Supplemental attachment
IMMA.attachments[99] = 'supplemental';
IMMA.parameters[99]  = ['ATTE','SUPD'];
IMMA.definitions[99] = {
    ATTE : [ 1,     null,  null,  null,  null,  null,  1 ],
    SUPD : [ null,  null,  null,  null,  null,  null,  3 ]
};
