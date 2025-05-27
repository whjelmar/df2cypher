test_that("preview_cypher prints to console", {
  lines <- c("CREATE (:Person {name: 'Alice'})")
  expect_output(preview_cypher(lines), "Alice")
})