test_that("preview_cypher returns first n lines", {
  stmts <- paste("MATCH (n) RETURN n", 1:10)
  preview <- preview_cypher(stmts, n = 3)
  expect_equal(length(preview), 3)
})