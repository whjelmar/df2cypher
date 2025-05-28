test_that("apply_naming_convention handles 'snake' case", {
  expect_equal(apply_naming_convention("User Profile", "snake"), "user_profile")
  expect_equal(apply_naming_convention("userProfile", "snake"), "user_profile")
  expect_equal(apply_naming_convention("  multiple   spaces", "snake"), "multiple_spaces")
})

test_that("apply_naming_convention handles 'camel' case", {
  expect_equal(apply_naming_convention("User Profile", "camel"), "userProfile")
  expect_equal(apply_naming_convention("Super Admin Officer", "camel"), "superAdminOfficer")
})

test_that("apply_naming_convention handles 'pascal' case", {
  expect_equal(apply_naming_convention("User Profile", "pascal"), "UserProfile")
  expect_equal(apply_naming_convention("data engineer lead", "pascal"), "DataEngineerLead")
})

test_that("apply_naming_convention handles 'upper' case", {
  expect_equal(apply_naming_convention("User Profile", "upper"), "USER_PROFILE")
  expect_equal(apply_naming_convention("hello-world", "upper"), "HELLO_WORLD")
})

test_that("apply_naming_convention handles 'lower' case", {
  expect_equal(apply_naming_convention("User Profile", "lower"), "userprofile")
  expect_equal(apply_naming_convention("Mixed CASE+Symbols", "lower"), "mixedcasesymbols")
})

test_that("apply_naming_convention handles 'as_is' and unknown styles", {
  expect_equal(apply_naming_convention("As-Is", "as_is"), "As-Is")
  expect_equal(apply_naming_convention("KeepMe", "unknown_style"), "KeepMe")
})

test_that("apply_naming_convention handles edge cases", {
  expect_equal(apply_naming_convention("", "snake"), "")
  expect_equal(apply_naming_convention(NA, "pascal"), "NA")
  expect_equal(apply_naming_convention(123, "camel"), "123")
})
