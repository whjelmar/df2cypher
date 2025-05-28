# 📍 `df2cypher` Project Roadmap

## Recently Completed (v0.1.3)

### 🔧 Functional Enhancements
- [ ] Support **automatic property typing**:
  - Strings, numbers, booleans converted from tibble automatically.
  - Option to override via schema or hints.

---

## 🔭 Future Enhancements (v0.1.4+)

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
