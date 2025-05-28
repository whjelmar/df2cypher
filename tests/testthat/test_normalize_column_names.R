test_that("normalize_column_names converts camelCase to snake_case", {
  df <- data.frame(idValue = 1:3, stringsAsFactors = FALSE)
  df2 <- normalize_column_names(df)
  expect_equal(names(df2), "id_value")
})