test_that("df_to_cypher_relationship respects direction", {
  df <- data.frame(
    from = c("X", "Y"),
    to = c("Y", "Z"),
    stringsAsFactors = FALSE
  )

  result_out <- df_to_cypher_relationship(df, direction = "out", from_col = "from", to_col = "to")
  result_in <- df_to_cypher_relationship(df, direction = "in", from_col = "from", to_col = "to")
  result_both <- df_to_cypher_relationship(df, direction = "undirected", from_col = "from", to_col = "to")

  expect_true(all(grepl("->", result_out)))
  expect_true(all(grepl("<-", result_in)))
  expect_error(
    df_to_cypher_relationship(df, direction = "both", from_col = "from", to_col = "to"),
    "Invalid direction"
  )
  
})

