context("Read")

test_that("Read an observations file from disc", {

# Basic
  
   i.file<-system.file("extdata/tests", "basic.imma", package = "IMMA")
   d.file<-system.file("extdata/tests", "basic.Rdata", package = "IMMA")
   load(d.file) 
   o<-ReadObs(i.file)
   expect_equal(basic,o)
   
# Records with varying attachments
  
   i.file<-system.file("extdata/tests", "mixed_attachments.imma", package = "IMMA")
   d.file<-system.file("extdata/tests", "mixed_attachments.Rdata", package = "IMMA")
   load(d.file) 
   o<-ReadObs(i.file)
   expect_equal(mixed_attachments,o)  

# All sorts of different attachments
  
   i.file<-system.file("extdata/tests", "IMMA1_0+1+5+6+7+8+9+98+99.imma", package = "IMMA")
   d.file<-system.file("extdata/tests", "IMMA1_01567899899.Rdata", package = "IMMA")
   load(d.file) 
   o<-ReadObs(i.file)
   expect_equal(IMMA1_01567899899,o)  

})

