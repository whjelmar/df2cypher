test_that("df_to_cypher_node works", {
  df <- data.frame(id = 1, name = "Test")
  cypher <- df_to_cypher_node(df, label = "Person")
  expect_true(grepl("CREATE", cypher[1]))
})