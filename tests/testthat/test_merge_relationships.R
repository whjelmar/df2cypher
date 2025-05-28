test_that("df_to_cypher_relationship with use_merge = TRUE returns MERGE statements", {
  df <- data.frame(
    src = c("a", "b"),
    dst = c("b", "c"),
    stringsAsFactors = FALSE
  )

  result <- df_to_cypher_relationship(df, use_merge = TRUE, rel_type = "CONNECTED", from_col = "src", to_col = "dst")
  expect_true(all(grepl("MERGE", result)))
})