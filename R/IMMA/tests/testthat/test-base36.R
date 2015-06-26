context("Base36")

test_that("Base36 numbers decoded correctly", {

  

  set_colours("red")
  expect_error(set_colours(rep("red", 2)), "Incompatible lengths")
  dev.off()  # Need to manually close device because of error
  expect_error(set_colours(rep("red", 3)), "Incompatible lengths")
  dev.off()
  expect_error(set_colours(rep("red", 4)), "Incompatible lengths")
  dev.off()
  set_colours(rep("red", 5))


})
