test_that("df_to_cypher_node works", {
  df <- tibble::tibble(id = 1:2, name = c("Alice", "Bob"))
  cypher <- df_to_cypher_node(df, "Person", "id")
  
  expect_true(all(grepl("^CREATE", cypher)))
  expect_true(any(grepl("Alice", cypher)))
})

test_that("df_to_cypher_relationship works", {
  df <- tibble::tibble(from = 1, to = 2, since = 2020)
  cypher <- df_to_cypher_relationship(df, "Person", "Person", "KNOWS", "from", "to", "since")
  
  expect_true(all(grepl("^MATCH", cypher)))
  expect_true(any(grepl("2020", cypher)))
})
