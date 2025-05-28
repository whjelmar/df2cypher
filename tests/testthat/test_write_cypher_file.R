test_that("write_cypher_file creates a file with Cypher statements", {
  tmp <- tempfile(fileext = ".cypher")
  on.exit(unlink(tmp))
  stmts <- c("CREATE (n)", "RETURN n")
  write_cypher_file(stmts, tmp)
  written <- readLines(tmp)
  expect_equal(written, stmts)
})