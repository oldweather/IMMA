context("Write")
library(tools)  # md5sum function

test_that("Write an observations data frame to disc", {

# Basic
  
   i.file<-system.file("extdata/tests", "basic.imma", package = "IMMA")
   d.file<-system.file("extdata/tests", "basic.Rdata", package = "IMMA")
   load(d.file)
   of.name<-tempfile()
   WriteObs(basic,of.name)
   expect_true(md5sum(i.file) == md5sum(of.name))
   file.remove(of.name)
   
# Records with varying attachments
  
   i.file<-system.file("extdata/tests", "mixed_attachments.imma", package = "IMMA")
   d.file<-system.file("extdata/tests", "mixed_attachments.Rdata", package = "IMMA")
   load(d.file) 
   of.name<-tempfile()
   WriteObs(mixed_attachments,of.name)
   expect_true(md5sum(i.file) == md5sum(of.name))
   file.remove(of.name)

# All sorts of different attachments
  
   i.file<-system.file("extdata/tests", "IMMA1_0+1+5+6+7+8+9+98+99.imma", package = "IMMA")
   d.file<-system.file("extdata/tests", "IMMA1_01567899899.Rdata", package = "IMMA")
   load(d.file) 
   of.name<-tempfile()
   WriteObs(IMMA1_01567899899,of.name)
   expect_true(md5sum(i.file) == md5sum(of.name))
   file.remove(of.name)

})

