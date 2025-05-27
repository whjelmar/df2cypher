# df2cypher

> 🔁 Convert `data.frame` or `tibble` objects to Cypher `CREATE` statements for Neo4j nodes and relationships.

## Overview

The `df2cypher` package makes it easy to transform structured tabular data into Cypher code that can be used to populate a Neo4j graph database. This is especially useful for quick imports or generating reproducible graph definitions from R-based data workflows.

## Features

- 🧱 Convert rows into `CREATE` statements for Neo4j nodes
- 🔗 Generate Cypher code for relationships between nodes
- 🧪 Includes unit tests using `testthat`
- 🧾 Documented with `roxygen2`
- 🔌 JSON-based property serialization for compatibility

---

## Installation

```r
# Recommended: use `devtools` or `pak` to install from local folder or GitHub
# devtools::install_github("your-username/df2cypher")
# OR after downloading:
devtools::install_local("path/to/df2cypher.zip")
```

---

## Usage

### Create Nodes

```r
library(df2cypher)
library(tibble)

nodes <- tibble::tibble(id = 1:2, name = c("Alice", "Bob"))
cypher_code <- df_to_cypher_node(nodes, label = "Person", id_column = "id")
cat(cypher_code, sep = "\n")
```

**Output:**
```cypher
CREATE (:Person {id: 1, name: "Alice"})
CREATE (:Person {id: 2, name: "Bob"})
```

---

### Create Relationships

```r
rels <- tibble::tibble(from = 1, to = 2, since = 2020)
cypher_code <- df_to_cypher_relationship(
  rels,
  from_label = "Person",
  to_label = "Person",
  rel_type = "KNOWS",
  from_col = "from",
  to_col = "to",
  props_cols = "since"
)
cat(cypher_code, sep = "\n")
```

**Output:**
```cypher
MATCH (a:Person { from: 1 }), (b:Person { to: 2 }) CREATE (a)-[:KNOWS {since: 2020}]->(b)
```

---

## Requirements

```r
Imports:
  glue,
  jsonlite,
  purrr,
  tibble,
  testthat
```

---

## Development

- Uses `roxygen2` for documentation.
- Tests live in `tests/testthat`.
- Style follows tidyverse principles.

---

## License

MIT

## Author

Created by [Your Name], 2025.
