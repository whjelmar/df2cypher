% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/df_to_cypher_relationship.R
\name{df_to_cypher_relationship}
\alias{df_to_cypher_relationship}
\title{Convert a data frame into Cypher relationship statements}
\usage{
df_to_cypher_relationship(
  df,
  rel_type = "RELATES_TO",
  from_col,
  to_col,
  direction = "out",
  use_merge = FALSE,
  on_create = NULL,
  on_match = NULL
)
}
\arguments{
\item{df}{A data frame containing relationship data.}

\item{rel_type}{A string indicating the type of relationship (e.g., "KNOWS").}

\item{from_col}{The column name containing the source node IDs.}

\item{to_col}{The column name containing the target node IDs.}

\item{direction}{Relationship direction: one of "out" (default), "in", or "undirected".}

\item{use_merge}{Logical. If TRUE, uses `MERGE` instead of `CREATE`.}

\item{on_create}{Optional named list of properties to set using `ON CREATE SET`.}

\item{on_match}{Optional named list of properties to set using `ON MATCH SET`.}
}
\value{
A character vector of Cypher relationship statements.
}
\description{
Generates Cypher `CREATE` or `MERGE` statements for relationships based on a data frame.
Supports directional and undirected relationships, optional attributes, and conditional
`ON CREATE` / `ON MATCH` clauses. Uses a quoting function to handle automatic type conversion.
}
