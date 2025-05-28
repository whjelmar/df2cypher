test_that("df_to_cypher_node quotes values correctly", {
  df <- data.frame(
    id = 1,
    name = 'Alice "Admin"',
    role = "manager",
    is_active = TRUE,
    age = 42,
    stringsAsFactors = FALSE
  )
  
  result <- df_to_cypher_node(df, label = "User", id_column = "id")
  
  # Check presence of properly quoted string (use regex to match inner quote)
  expect_true(any(grepl('name: \\"Alice.*Admin\\"', result)))
  expect_true(any(grepl('role: "manager"', result)))
  expect_true(any(grepl('is_active: true', result)))
  expect_true(any(grepl('age: 42', result)))
})

test_that("df_to_cypher_relationship quotes values correctly", {
  df <- data.frame(
    from = 1,
    to = 2,
    since = '2024-01-01',
    active = FALSE,
    comment = 'Met at "Summit"',
    stringsAsFactors = FALSE
  )
  
  result <- df_to_cypher_relationship(
    df,
    rel_type = "KNOWS",
    from_col = "from",
    to_col = "to",
    use_merge = TRUE,
    on_create = list(comment = df$comment[1], active = df$active[1])
  )
  
  expect_true(any(grepl('comment: \\"Met.*Summit\\"', result)))
  expect_true(any(grepl('active: false', result)))
})
