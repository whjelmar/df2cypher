# df2cypher Style Guide

This document outlines the coding, design, and testing standards for the `df2cypher` R package.

---

## 🔧 General Coding Practices

1. **Use `glue::glue()` for all string interpolation.**  
   - Avoid `paste0()`, `sprintf()`, and `paste()` for constructing Cypher strings.  
   - ✅ Example: `glue("(:{label} {{id: \"{id}\"}})")`

2. **Avoid reserved words as unquoted argument names.**  
   - Quote direction keys in `switch()`:
     ```r
     switch(direction, "out" = ..., "in" = ..., "both" = ...)
     ```

3. **Use consistent parameter names across the codebase and tests.**  
   - Use: `from_col`, `to_col`, `rel_type`, `from_label`, `to_label`, `direction`, `use_merge`, `on_create_set`, `on_match_set`

4. **Respect and distinguish `MERGE` and `CREATE` operations.**  
   - If `use_merge = TRUE`, use `MERGE`.  
   - Support optional `ON CREATE SET` and `ON MATCH SET` clauses.

---

## 📐 Design and Logic Behavior

5. **Generate valid Cypher syntax in all outputs.**  
   - Format properties: `(:Label {property: "value"})`  
   - Quote strings and ensure syntax correctness

6. **Respect relationship directionality.**  
   - `"out"` → `()-[]->()`  
   - `"in"` → `()<-[ ]-()`  
   - `"both"` → `()-[ ]-()`

7. **Favor tidyverse-style readability.**  
   - Use vectorized expressions and clear code, avoid over-functional patterns

---

## 🧪 Testing and Testthat Expectations

8. **Provide test coverage for all exported functions.**  
   - Tests should check:
     - Structure and type of output
     - Presence of key Cypher components (e.g., `MERGE`, `ON CREATE SET`)
     - Correct behavior for different `direction` values

9. **Prefer `expect_true(grepl(...))` or `expect_match()` over exact string matches.**  
   - This allows for formatting differences without breaking the tests

10. **Use predefined test data frames inline.**  
   - Name consistently (e.g., `df`, `node_df`, `rel_df`)

---

## 📦 Packaging Standards

11. **Ensure package loads cleanly with `devtools::load_all()`.**  
   - No parse errors, unescaped characters, or invalid syntax

12. **Keep `R/` and `tests/testthat/` in sync.**  
   - Update both when function signatures change

