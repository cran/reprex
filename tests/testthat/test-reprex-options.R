test_that("reprex.current_venue is set", {
  skip_on_cran()
  input <- "getOption('reprex.current_venue')"
  ret <- reprex(input = paste0(input, "\n"))
  expect_match(ret, "gh", all = FALSE)
  ret <- reprex(input = paste0(input, "\n"), venue = "html")
  expect_match(ret, "html", all = FALSE)
})

test_that("`session_info` can be set via option", {
  skip_on_cran()
  withr::with_options(
    list(reprex.session_info = TRUE),
    out <- reprex(1, render = FALSE)
  )
  expect_match(out, "session_*[iI]nfo", all = FALSE)
})

test_that("`advertise` can be set via option", {
  skip_on_cran()
  withr::with_options(
    list(reprex.advertise = FALSE),
    out <- reprex(1, render = FALSE)
  )
  expect_false(any(grepl("#+ reprex-ad", out, fixed = TRUE)))
})

test_that("`comment` can be set via option", {
  skip_on_cran()
  withr::with_options(
    list(reprex.comment = "#? "),
    out <- reprex(rnorm(1))
  )
  expect_match(out, "^#\\?", all = FALSE)
})

test_that("`tidyverse_quiet` can be set via option", {
  skip_on_cran()
  withr::with_options(
    list(reprex.tidyverse_quiet = FALSE),
    out <- reprex(mean(1:3), render = FALSE)
  )
  expect_match(out, "tidyverse_quiet: FALSE", fixed = TRUE, all = FALSE)
})

test_that("`std_out_err` can be set via option", {
  skip_on_cran()
  withr::with_options(
    list(reprex.std_out_err = TRUE),
    out <- reprex(1, render = FALSE)
  )
  expect_match(out, "std_out_err", all = FALSE)
})
