# df2cypher News

## v0.1.2

### ✨ Features

- **Dynamic Relationship Type Naming**
  - `df_to_cypher_relationship()` now supports deriving relationship type names from a column in the data frame.
  - Naming convention styles include:
    - `snake_case`
    - `camelCase`
    - `PascalCase`
    - `UPPER_CASE`
    - `lowercase`
    - `as_is` (default)

- **New Helper**: `apply_naming_convention()` for label/type style transformations.

### ✅ Backward Compatibility

- Default behavior remains unchanged unless the new `rel_type_column` argument is specified.

---

## v0.1.1 
### 🚀 New Features
- Added support for **directional control in relationships** via the `direction` parameter in `df_to_cypher_relationship()`, supporting `"out"`, `"in"`, and `"undirected"` modes.
- Introduced new utility function: `normalize_column_names()` to standardize column names used in Cypher generation.
- Added `write_cypher_file()` to support writing generated Cypher statements to disk.

### 🧪 Tests & Quality
- Comprehensive unit test coverage added for all core functions.
- Directional logic now fully tested and validated for all relationship modes.
- Established a consistent internal test style based on new coding standards.

### 🛠 Refactoring & Style
- Rewrote internal glue-based Cypher statement generation to conform with new [`STYLE_GUIDE.md`](./STYLE_GUIDE.md) rules (e.g., use of `glue()` over `paste0()`).
- Removed redundant or unused arguments and improved function argument defaults.

### 📄 Documentation
- Added roxygen2-based documentation for all public-facing functions.
- Clarified function purpose and expected inputs/outputs.
- Added runnable examples for exportable functions like `write_cypher_file()` and `preview_cypher()`.

### 🔧 Internal Maintenance
- Removed unused dependencies from `Imports`: `janitor`, `jsonlite`, `testthat`, `tibble`.
- Fixed `R CMD check` NOTE about `head()` by importing from `utils`.

---

## 0.1.0 - Initial Release
- Added `df_to_cypher_node()` to generate Cypher node `CREATE` statements
- Added `df_to_cypher_relationship()` to generate Cypher relationship `CREATE` statements
- Added utility functions: `write_cypher_file()`, `preview_cypher()`, `normalize_column_names()`
- Integrated unit tests using `testthat`
- Roxygen2 documentation and `NAMESPACE` generation