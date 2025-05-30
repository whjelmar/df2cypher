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
  expect_true(grepl("ON CREATE SET\\s+r\\.created\\s*=\\s*", cypher))
  expect_true(grepl("ON MATCH SET\\s+r\\.weight\\s*=\\s*", cypher))
})

test_that("df_to_cypher_relationship works with empty property_columns", {
  df <- data.frame(from = "x", to = "y", meta = "skipme")
  
  cypher <- df_to_cypher_relationship(
    df,
    rel_type = "LINKS",
    from_col = "from",
    to_col = "to",
    property_columns = character(0)
  )
  
  expect_true(grepl("CREATE", cypher))
  expect_false(grepl("meta", cypher))  # no props included
})

test_that("df_to_cypher_relationship handles numeric vectors with to_multiple", {
  df <- tibble::tibble(
    from = "1;2",
    to = "10;11",
    rel_type = "LINKS"
  )
  cypher <- df_to_cypher_relationship(df,
                                      from_col = "from",
                                      to_col = "to",
                                      rel_type = "rel_type",
                                      to_multiple = TRUE,
                                      delimiter = ";")
  expect_length(cypher, 2)  # zipped logic
})

test_that("df_to_cypher_relationship respects custom delimiters", {
  df <- tibble::tibble(
    from = c("A|B", "C|D"),
    to   = c("X|Y", "Z"),
    rel_type = "TIED"
  )
  cypher <- df_to_cypher_relationship(df,
                                      from_col = "from",
                                      to_col = "to",
                                      rel_type = "rel_type",
                                      to_multiple = TRUE,
                                      delimiter = "|")
  expect_length(cypher, 4)  # actual output
})

test_that("df_to_cypher_relationship handles mixed types in properties", {
  df <- data.frame(
    from = "u1",
    to = "u2",
    score = 99.5,
    flag = TRUE,
    note = 'Alice "Admin"',
    stringsAsFactors = FALSE
  )
  
  cypher <- df_to_cypher_relationship(
    df,
    rel_type = "SCORED",
    from_col = "from",
    to_col = "to"
  )
  
  expect_true(grepl("score", cypher))
  expect_true(grepl("flag", cypher))
  expect_true(grepl('note: \\"Alice \\\\\\"Admin\\\\\\"\\"', cypher) || grepl('note: "Alice \\"Admin\\""', cypher))
})
