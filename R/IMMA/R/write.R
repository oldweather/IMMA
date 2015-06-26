# Make a string representation of an attachment
EncodeAttachment <- function(ob,attachment){

    Result = rep('',length(ob$YR))
    for ( parameter in names(definitions[[attachment]])) {
        definitions<-DefinitionsFor(parameter)

        # Treat differently according to type
        if(definitions[7]==3) { # Character, just print
          w<-which(!is.null(ob[[parameter]]))
          if(length(w)>0) {
              if(!is.null(definitions[1])) {
                 Result[w]<-sprintf(sprintf("%%s%%.%ds",definitions[1]),Result[w],ob[[parameter]][w])
              } else {  # Unspecified length, supplementary only - use length of data
                 Result[w]<-sprintf("%s%s",Result[w],ob[[parameter]][w])
              }
          }
          if(length(w)<length(Result)) { # Missing and bad values are encoded as blanks
              if(!is.null(definitions[1])) {
                 Result[!w]<-sprintf(sprintf("%%s%%.%ss",definitions[1]),Result[!w],' ')
              } else {  # Unspecified length, supplementary only - use length of data
                 Result<-sprintf("%s%s",Result[!w],' ')
              }
          }
        }
        if(definitions[7]==1) { # Integer - check, scale, round and print
          w<-which(!is.na(ob[[parameter]]) & CheckParameter(ob,parameter))
          if(length(w)>0) {
             scaled<-ob[[parameter]][w]/definitions[6]
             round<-as.integer(scaled+0.5) # nearest integer
             Result[w]<-sprintf(sprintf("%%s%%.%dd",definitions[1]),Result[w],round)
         }
          if(length(w)<length(Result)) { # Missing and bad values are encoded as blanks
             Result[!w]<-sprintf(sprintf("%%s%%.%ds",definitions[1]),Result[!w],' ')
          }
         }
        if(definitions[7]==2) { # Base36 - check, scale, convert and print
          w<-which(!is.na(ob[[parameter]]) & CheckParameter(ob,parameter))
          if(length(w)>0) {
             scaled<-ob[[parameter]][w]/definitions[6]
             round<-as.integer(scaled+0.5) # nearest integer
             enc<-EncodeBase36(round)
             Result[w]<-sprintf(sprintf("%%s%%.%ds",definitions[1]),Result[w],round)
         }
          if(length(w)<length(Result)) { # Missing and bad values are encoded as blanks
             Result[!w]<-sprintf(sprintf("%%s%%.%ds",definitions[1]),Result[!w],' ')
          }
         }
      }
    # Done all the parameters, add the ID and length to the start
    # (except for core)
    if ( attachment != 'C0' ) {
        if ( attachment == 'C99' ) {
            Result = sprintf(" 0%s",Result)
        } else {
            Result = sprintf("%2d%s",nchar(Result)+4,Result)
        }
        Result = sprintf("%2d%s",attachment,Result)
    }

    return(Result)
}

# Make a string version of the whole record
PackString <- function(ob) {
    Result = rep('',length(ob$YR))
    for(attachment in c('C0','C1','C2','C3','C4','C5','C6','C7','C8','C9',
                       'C95','C96','C97','C98','C99')) {
      w<-HasAttachment(ob,attachment)
      if(length(w)>0) {
        Result[w]<-sprintf("%s%s",Result,EncodeAttachment(ob[w,],attachment))
      }
    }
    return(Result)
}

