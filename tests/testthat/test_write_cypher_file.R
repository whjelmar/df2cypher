test_that("write_cypher_file writes output correctly", {
  tmp <- tempfile(fileext = ".cypher")
  lines <- c("CREATE (:Person {name: 'Alice'})", "CREATE (:Person {name: 'Bob'})")
  write_cypher_file(lines, tmp)
  result <- readLines(tmp)
  expect_equal(result, lines)
})