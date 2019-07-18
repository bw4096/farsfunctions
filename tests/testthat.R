library(testthat)
library(farsfunctions)

#test_check("farsfunctions")


# test fars_read_years
test_that('test fars_read_years', {
  # warning when a year does not exist
  yrs <- 2012:2015
  expect_warning(fars_read_years(yrs),
                 "invalid year: 2012")
})
