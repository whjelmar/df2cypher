test_that("normalize_column_names converts names to snake_case", {
  df <- tibble::tibble("Full Name" = "Alice", `Start Date` = Sys.Date())
  cleaned <- normalize_column_names(df)
  expect_equal(names(cleaned), c("full_name", "start_date"))
})