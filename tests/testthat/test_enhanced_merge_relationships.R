test_that("MERGE relationship with ON CREATE SET and ON MATCH SET works", {
  df <- data.frame(
    from = c("1", "2"),
    to = c("2", "3"),
    rel_prop = c("foo", "bar"),
    stringsAsFactors = FALSE
  )

  result <- df_to_cypher_relationship(
    df,
    use_merge = TRUE,
    rel_type = "CONNECTED",
    from_col = "from",
    to_col = "to"
  )

  expect_true(all(grepl("MERGE", result)))
})
