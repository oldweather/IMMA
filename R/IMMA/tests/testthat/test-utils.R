context("WhichAttachment")

test_that("Parameters correctly matched to Attachments", {

   expect_identical('C0',WhichAttachment('SST'))
   expect_identical('C5',WhichAttachment('IC3'))
   expect_identical('C6',WhichAttachment('MSH'))
   expect_identical('C7',WhichAttachment('MDS'))
   expect_identical('C8',WhichAttachment('PUID'))
   expect_identical('C9',WhichAttachment('NHe'))
   expect_identical('C95',WhichAttachment('MFGSR'))
   expect_identical('C96',WhichAttachment('VQC'))
   expect_identical('C97',WhichAttachment('ERRD'))
   expect_identical('C98',WhichAttachment('IRF'))
   expect_identical('C99',WhichAttachment('SUPD'))
   expect_error(WhichAttachment('sst'),'No parameter sst in IMMA-1')

})

context("DefinitionsFor")

test_that("Correct definitions extracted for parameters", {

   expect_identical(list( 4,  -99.9,    99.9,    NA,    NA,   0.1,    1 ),
                    DefinitionsFor('SST'))
   expect_identical(list( 6, 48.,   57.,    65.,   90.,   NA,  3 ),
                    DefinitionsFor('BUID'))
   expect_error(DefinitionsFor('sst'),'No parameter sst in IMMA-1')

})

context("CheckParameter")

test_that("Parameter range checking works OK", {

   expect_identical(TRUE,CheckParameter(23.0,'SST'))
   expect_identical(FALSE,CheckParameter(230.0,'SST'))
   expect_identical(c(FALSE,TRUE),CheckParameter(c(-100,10),'SST'))
   expect_error(CheckParameter(23.0,'sst'),'No parameter sst in IMMA-1')

})


