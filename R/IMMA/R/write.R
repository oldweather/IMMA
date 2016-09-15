# Make a string representation of an attachment
EncodeAttachment <- function(ob,attachment){

    Result = rep('',length(ob$YR))
    for ( parameter in names(definitions[[attachment]])) {
        l.definitions<-DefinitionsFor(parameter)

        # Treat differently according to type
        if(l.definitions[7]==3) { # Character, just print
          w<-which(!is.na(ob[[parameter]]))
          if(length(w)>0) {
              if(!is.na(l.definitions[[1]])) {
                 Result[w]<-sprintf(sprintf("%%s%%%ds",l.definitions[[1]]),Result[w],ob[[parameter]][w])
              } else {  # Unspecified length, supplementary only - use length of data
                 Result[w]<-sprintf("%s%s",Result[w],ob[[parameter]][w])
              }
          }
          if(length(w)<length(Result)) { # Missing and bad values are encoded as blanks
              if(!is.na(l.definitions[[1]])) {
                 if(length(w)>0) {
                    Result[-w]<-sprintf(sprintf("%%s%%%ds",l.definitions[[1]]),Result[-w],' ')
                 } else {
                    Result<-sprintf(sprintf("%%s%%%ds",l.definitions[[1]]),Result,' ')
                 }
              } else {  # Unspecified length, supplementary only - use length of data
                 if(length(w)>0) {
                    Result[-w]<-sprintf("%s%s",Result[-w],' ')
                 } else {
                   Result<-sprintf("%s%s",Result,' ')
                 }
              }
          }
        }
        if(l.definitions[7]==1) { # Integer - check, scale, round and print
          w<-which(!is.na(ob[[parameter]]) & CheckParameter(ob[[parameter]],parameter))
          if(length(w)>0) {
             scaled<-ob[[parameter]][w]/l.definitions[[6]]
             round<-round(scaled) # nearest integer
             Result[w]<-sprintf(sprintf("%%s%%%dd",l.definitions[[1]]),Result[w],round)
         }
          if(length(w)<length(Result)) { # Missing and bad values are encoded as blanks
             if(length(w)>0) {
                 Result[-w]<-sprintf(sprintf("%%s%%%ds",l.definitions[[1]]),Result[-w],' ')
             } else {
                 Result<-sprintf(sprintf("%%s%%%ds",l.definitions[[1]]),Result,' ')
             } 
          }
         }
        if(l.definitions[7]==2) { # Base36 - check, scale, convert and print
          w<-which(!is.na(ob[[parameter]]) & CheckParameter(ob[[parameter]],parameter))
          if(length(w)>0) {
             scaled<-ob[[parameter]][w]/l.definitions[[6]]
             round<-round(scaled) # nearest integer
             enc<-EncodeBase36(round)
             Result[w]<-sprintf(sprintf("%%s%%%ds",l.definitions[[1]]),Result[w],enc)
         }
          if(length(w)<length(Result)) { # Missing and bad values are encoded as blanks
             if(length(w)>0) {
                Result[-w]<-sprintf(sprintf("%%s%%%ds",l.definitions[[1]]),Result[-w],' ')
             } else {
               Result<-sprintf(sprintf("%%s%%%ds",l.definitions[[1]]),Result,' ')
             }
          }
         }
      }
    # Done all the parameters, add the ID and length to the start
    # (except for core)
    if ( attachment != 'C0' ) {
        if ( attachment == 'C99' ) {
            Result = sprintf(" 0%s",Result)
        } else {
           if( attachment == 'C8' ) {
              Result = sprintf("2U%s",Result) # Special case as > 100 chars
            } else {
              Result = sprintf("%2d%s",nchar(Result)+4,Result)
            }
        }
        Result = sprintf("%2d%s",as.integer(substr(attachment,2,10)),Result)
    }

    return(Result)
}

# Make a string version of the whole record
PackString <- function(ob) {
    Result = rep('',length(ob$YR))
    for(attachment in c('C0','C1','C2','C3','C4','C5','C6','C7','C8','C9',
                       'C95','C96','C97','C98','C99')) {
      w<-which(HasAttachment(ob,attachment))
      if(length(w)>0) {
        Result[w]<-sprintf("%s%s",Result[w],EncodeAttachment(ob[w,],attachment))
      }
    }
    return(Result)
}

#' Write out a data frame of IMMA records to a connection
#'
#' Operates on a data frame - like that produced by \code{ReadObs}.
#'
#' Currently supports IMMA1 format (Rev. 17) - only main record files,
#'  not extension files.
#'
#' @export
#' @param obs - Data frame of imma obs.
#' @param con Connection to write data to - or string, see \code{readLines()}.
WriteObs<-function(obs,con) {
  lines<-PackString(obs)
  writeLines(lines,con)
}
