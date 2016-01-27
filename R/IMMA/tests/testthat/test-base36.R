context("Base36")

test_that("Base36 numbers decoded correctly", {

   expect_identical(32L,DecodeBase36('w'))
   expect_identical(32L,DecodeBase36('W'))
   expect_identical(7L,DecodeBase36(7))
   expect_identical(1161L,DecodeBase36('w9'))
  
})

test_that("Base36 numbers encoded correctly", {

   expect_identical(EncodeBase36(32),'W')
   expect_identical(EncodeBase36(1161),'W9')
   expect_identical(EncodeBase36(32,p=2),'0W')

})
