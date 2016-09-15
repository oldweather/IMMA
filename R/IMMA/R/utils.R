#' Find out which attachment a parameter is in
#'
#' IMMA data are divided into core parameters and optional attachments
#' this function gives the attachment number of a parameter name.
#'
#' Throws error if parameter isn't in any attachment.
#'
#' @export
#' @param parameter - Name of parameter to be found
#' @return the number of the attachment containing that parameter.
WhichAttachment <- function(parameter) {
    if(missing(parameter)) stop ("Need parameter as function argument")
    for(i in c('C0','C1','C5','C6','C7','C8','C9',
               'C95','C96','C97','C98','C99',
               'C2','C3','C4')) {
        if(!is.null(definitions[[i]][[parameter]])) { return(i) }
    }
    stop(sprintf("No parameter %s in IMMA-1",parameter))
}

# Get the definitions for a named parameter
DefinitionsFor <- function(parameter,current=NULL) {
    if(parameter=='ERRD') {
       if(current[[ICNE]]==0) inherits.attachment<-'C0'
       else inherits.attachment<-attachments[current[[ICNE]]]
       inherits.parameter<-names(definitions[[inherits.attachment]])[current[[FNE]]]# FNE-2?
       inherits.definitions<-DefinitionsFor(inherits.parameter)
       return(inherits.definitions)
    }
    return(definitions[[WhichAttachment(parameter)]][[parameter]])
}

# Convert between numeric and base 36
DecodeBase36 <- function(s) { return(strtoi(s,36)) }
# p specifies a minimum number of characters
EncodeBase36 <- function(n,p=0) {
    n<-as.integer(n)
    s<-rep("",length(n))
    w<-which(n==0)
    if(length(w)>0) s[w]<-'0'
    w<-which(n>0)
    while (length(w)>0) {
       s[w] <- paste(substr(rep("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ",length(n[w])),
                          n[w]%%36+1,n[w]%%36+1),
                   s[w],sep='')
       n <-as.integer(n/36)
       w<-which(n>0)
    }
    w<-which(nchar(s)<p)
    # Pad strings of less than minimum length with zeros
    while(length(w)>0) {
      s[w]<-paste('0',s[w],sep='')
      w<-which(nchar(s)<p)
    }
    return(s)
}

#' Check the value for a parameter is inside its acceptable range(s)
#'
#' Flags data which is physically impossible and can't be written in IMMA.
#'
#' The IMMA format constrains the possible ranges of numeric parameters
#'  data outside those ranges can't be written in the format.This function
#'  tests all the data for a selected paramete is inside the acceptable range.
#'
#' @export
#' @param value values to be checked.
#' @param parameter - Name of parameter values correspond to
#' @return for each observation, TRUE if within range (or no range defined), FALSE if
#'  outside range.
CheckParameter <- function(value,parameter) {

  if(missing(parameter)) stop ("Need parameter as function argument")
  definitions=DefinitionsFor(parameter)
  if ( is.null(definitions) ) {
     stop("No parameter %s in IMMA.",parameter);
  }

  result<-rep(FALSE,length(value))
              
   # Character data can be anything
    if ( definitions[7] == 3 ) {
        return(result); 
    }
  
    w<-which(is.null(value) | is.na(value) |
             ((definitions[[2]]-definitions[[6]]/2 <= value)
        &     (definitions[[3]]+definitions[[6]]/2 >= value ))
        |    ((definitions[[4]]-definitions[[6]]/2 <= value)
        &     (definitions[[5]]+definitions[[6]]/2 >= value )))
    if(length(w)>0) result[w]<-TRUE
  return(result)
}

#' Find the records which have a particular attachment.
#'
#' Assumes all records have a Core attachment
#'
#' Used in writing IMMA - basically just to save writing null attachments
#'
#' @export
#' @param ob - Data frame of imma observations.
#' @param attachment - Identifier of attachment to be checked ('C0', 'C1', ...'C99').
#' @return for each observation, TRUE if attachment present, False otherwise
HasAttachment<-function(ob,attachment) {
  Result<-rep(FALSE,length(ob$YR))
  if(attachment=='C0') {
    Result<-rep(TRUE,length(Result))
  } else {
    w<-which(ob[[sprintf("has.%s",attachment)]])
    if(length(w)>0) Result[w]<-TRUE
  }
  return(Result)
}
