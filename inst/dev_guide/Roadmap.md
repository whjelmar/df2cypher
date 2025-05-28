# 📍 `df2cypher` Project Roadmap

## ✅ Recently Completed (v0.1.1)
- ✅ Full support for directed and undirected Cypher relationships.
- ✅ Core utilities implemented: `normalize_column_names`, `preview_cypher`, `write_cypher_file`.
- ✅ Full test coverage with `testthat`.
- ✅ Style guide enforcement and internal consistency improvements.

---

## 🗺️ Next Milestone (v0.2.0)

### 📘 Documentation & Vignettes
- [ ] Create `vignettes/df2cypher-intro.Rmd`:
  - Walkthrough of transforming a data frame into Cypher node and relationship statements.
  - Best practices for formatting input data.
- [ ] Create `vignettes/advanced-usage.Rmd`:
  - Merging, `ON CREATE SET` / `ON MATCH SET`, directionality, using with Neo4j via `neo4j` package or HTTP endpoint.
- [ ] Add examples for edge cases and quirks (e.g., NULLs, missing columns, quoting issues).

### 🔧 Functional Enhancements
- [ ] Support **automatic property typing**:
  - Strings, numbers, booleans converted from tibble automatically.
  - Option to override via schema or hints.
- [ ] Add **support for multiple relationships per row**.
- [ ] Implement **custom relationship attributes** (e.g., weights, timestamps).

### 🧪 Testing & Tooling
- [ ] Add performance tests for large data sets (10K–1M rows).
- [ ] Test with non-default tibbles, such as grouped tibbles or those with rownames.
- [ ] Add `covr::report()` integration for test coverage.

---

## 🔭 Future Enhancements (v0.3.x+)

### 🔌 Extensibility
- [ ] Add **template/plugin support** for Cypher output formatting.
- [ ] Allow user-defined mapping rules or transformation functions for property sets.

### 🔗 Integration Features
- [ ] Provide native functions to push data to Neo4j using the Bolt or HTTP API.
- [ ] Add optional support for `neo4j` R package or `reticulate` + Python drivers.
- [ ] Export `.cypher` scripts optimized for **Neo4j Browser**, **Bloom**, or **Data Import Wizard**.

---

## 🧹 Maintenance & Polish
- [ ] Remove unused dependencies (e.g., `janitor`, `jsonlite` if not used in prod).
- [ ] Add logo/badge and publish to GitHub Pages with pkgdown.
- [ ] Review and refine the `DESCRIPTION` file, long-form title, and CRAN-readiness.
