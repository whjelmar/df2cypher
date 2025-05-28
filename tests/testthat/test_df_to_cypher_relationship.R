test_that("df_to_cypher_relationship works", {
  df <- data.frame(from = c("a", "b"), to = c("b", "c"))
  cypher <- df_to_cypher_relationship(
    df,
    rel_type = "CONNECTED",
    from_col = "from",
    to_col = "to"
  )
  expect_length(cypher, 2)
  expect_true(all(grepl("CREATE", cypher)))
  expect_true(all(grepl("CONNECTED", cypher)))
})

test_that("df_to_cypher_relationship respects direction", {
  df <- data.frame(from = c("x"), to = c("y"))
  
  out_stmt <- df_to_cypher_relationship(df, rel_type = "CONNECTED_TO", direction = "out", from_col = "from", to_col = "to")
  in_stmt <-df_to_cypher_relationship(df, rel_type = "CONNECTED_TO", direction = "in", from_col = "from", to_col = "to")
  undirected_stmt <- df_to_cypher_relationship(df, rel_type = "CONNECTED_TO", direction = "undirected", from_col = "from", to_col = "to")
  
  expect_true(grepl("-\\[r:CONNECTED_TO\\]->", out_stmt))
  expect_true(grepl("<-\\[r:CONNECTED_TO\\]-", in_stmt))
  expect_true(all(grepl("-\\[r:CONNECTED_TO\\]-", undirected_stmt)))
})

test_that("df_to_cypher_relationship handles MERGE with ON CREATE and ON MATCH", {
  df <- data.frame(from = "user1", to = "user2")
  create_props <- list(created = "2020-01-01")
  match_props <- list(weight = 5)
  
  cypher <- df_to_cypher_relationship(
    df,
    rel_type = "KNOWS",
    from_col = "from",
    to_col = "to",
    use_merge = TRUE,
    on_create = create_props,
    on_match = match_props
  )
  
  expect_true(grepl("MERGE", cypher))
  expect_true(grepl("ON CREATE SET created:", cypher))
  expect_true(grepl("ON MATCH SET weight:", cypher))
})
