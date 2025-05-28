test_that("MERGE with ON CREATE and ON MATCH SET works", {
  df <- data.frame(id = "n1", status = "active", updated_at = "2025-01-01")
  cypher <- df_to_cypher_node(df)
  expect_true(grepl("status", cypher[1]))
  expect_true(grepl("updated_at", cypher[1]))
})
