# Unpack the string version of an attachment into a data frame
DecodeAttachment <- function(ob.strings,attachment){
   Result<-list()
   pstart<-1
   for (parameter in names(definitions[[attachment]])) {
      definitions<-DefinitionsFor(parameter,current=Results)
      if(!is.null(definitions[[1]])) {
         pstring<-substr(ob.strings,pstart,pstart+definitions[[1]]-1)
         pstart<-pstart+definitions[[1]]
         pstring<-sub("^\\s+", "", pstring) # strip leading blanks
      } else { # Variable length - tricky
         # Only get here for SUPD - take the rest of the string
         pstring<-substring(ob.strings,pstart)
      }
      w<-which(nchar(pstring)==0)        # all blank - set to missing
      
      if(definitions[7]==3) { # Character,add directly
        if(length(w)>0) {
           is.na(pstring[w])<-TRUE
        }
        Result[[parameter]]<-pstring
      }
      if(definitions[7]==2) { # Base36 - convert, scale and add
        pint<-integer(length(pstring))
        if(length(w)>0) {
           is.na(pint[w])<-TRUE
        }
        if(length(w)<length(pint)) {
          pint[-w]<-DecodeBase36(pstring[-w])
        }
        Result[[parameter]]<-pint*definitions[[6]]
      }
      if(definitions[7]==1) { # numeric data - scale and add
        pint<-as.integer(pstring)
        if(length(w)>0) {
           is.na(pint[w])<-TRUE
        }
        Result[[parameter]]<-pint*definitions[[6]]
      }
    }
   return(as.data.frame(Result,stringsAsFactors=FALSE))
}

# Unpack from string format into a data frame
ObsUnpack <- function(ob.strings) {

   # split the strings into a separate vector for each attachment
   atsplit<-list()
   # Core is always present and first
   atsplit[['C0']]<-substr(ob.strings,1,108)
   ob.strings<-substring(ob.strings,109)
   w<-which(nchar(ob.strings)>4)
   while(length(w)>0) {
     att.no<-as.integer(substr(ob.strings[w],1,2))
     att.len<-as.integer(substr(ob.strings[w],3,4))
     for(attachment in c('C0','C1','C2','C3','C4','C5','C6','C7','C8','C9',
                         'C95','C96','C97','C98')) {
        w2<-which(attachments[att.no]==attachment)
        if(length(w2)>0) {
          atsplit[[attachment]][w][w2]<-substr(ob.strings[w][w2],5,att.len)
          ob.strings[w][w2]<-substring(ob.strings[w][w2],att.len+1)
        }
      }
     attachment<-'C99' # No set length - use the rest of the string
     w2<-which(attachments[att.no]==attachment)
     if(length(w2)>0) {
       atsplit[[attachment]][w][w2]<-substring(ob.strings[w][w2],5)
       ob.strings[w][w2]<-''
     }
     w<-which(nchar(ob.strings)>4)
   }

   # Now create the data frame
   Result<-DecodeAttachment(atsplit[['C0']],'C0')
   for(attachment in  c('C1','C2','C3','C4','C5','C6','C7','C8','C9',
                         'C95','C96','C97','C98','C99')) {
     flagName<-sprintf("has.%s",attachment)
     Result[[flagName]]<-FALSE
     if(length(atsplit[[attachment]])>0) {
       w<-which(nchar(atsplit[[attachment]])>0)
       Result[[flagName]][w]<-TRUE
       if(length(w)<length(atsplit[[attachment]])) {
         atsplit[[attachment]][!w]<-''
       }
       length(atsplit[[attachment]])=length(Result$YR)
       Result<-cbind(Result,DecodeAttachment(atsplit[[attachment]],attachment))
     }
   }
   return(Result)
}


#' Read in all the IMMA records from a connection
#'
#' Keeps the data internally in a data frame - size
#'  depends on which attachments are present in the source.
#'
#' Currently supports IMMA1 format (Rev. 17) - only main record files,
#'  not extension files.
#'
#' @export
#' @param con Connection to read data from - or string, see readLines().
#' @param n - maximum number of records to read (negative means read all)
#'   repeatedly call with n=1 to get records 1 at a time, use n=-1
#'   (default) to get them all in one go.
#' @return data frame - 1 row per record, column names as in the IMMA
#'  documentation.
ReadObs<-function(con,n=-1) {
   l<-readLines(con=con,n=n)
   return(ObsUnpack(l))
}
  
