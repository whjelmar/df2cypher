test_that("quote_for_cypher handles strings", {
  expect_equal(quote_for_cypher("hello world"), '"hello world"')
  expect_equal(quote_for_cypher("name\"with\"quotes"), '"name\"with\"quotes"')
})

test_that("quote_for_cypher handles numbers", {
  expect_equal(quote_for_cypher(42), "42")
  expect_equal(quote_for_cypher(3.14), "3.14")
})

test_that("quote_for_cypher handles booleans", {
  expect_equal(quote_for_cypher(TRUE), "true")
  expect_equal(quote_for_cypher(FALSE), "false")
})

test_that("quote_for_cypher handles NA and NULL", {
  expect_equal(quote_for_cypher(NA), "null")
  expect_equal(quote_for_cypher(NULL), "null")
})

test_that("quote_for_cypher coerces factors and complex cases", {
  expect_equal(quote_for_cypher(factor("admin")), '"admin"')
})
