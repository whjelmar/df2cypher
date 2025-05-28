test_that("df_to_cypher_node with use_merge = TRUE returns MERGE statements", {
  df <- data.frame(
    id = c("1", "2"),
    name = c("Alice", "Bob"),
    stringsAsFactors = FALSE
  )

  result <- df_to_cypher_node(df, label = "Person", id_col = "id", use_merge = TRUE)
  expect_true(all(grepl("MERGE", result)))
})