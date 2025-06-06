% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/df_to_cypher_node.R
\name{df_to_cypher_node}
\alias{df_to_cypher_node}
\title{Convert a data frame to Cypher node creation statements}
\usage{
df_to_cypher_node(
  df,
  label = "Node",
  id_column = "id",
  use_merge = FALSE,
  label_column = NULL,
  naming_style = "as_is"
)
}
\arguments{
\item{df}{A data frame where each row represents a node.}

\item{label}{A static label for all nodes (default: "Node").}

\item{id_column}{Column to use as the node identifier (used only for validation).}

\item{use_merge}{Logical. If TRUE, generates `MERGE` instead of `CREATE`. Defaults to FALSE.}

\item{label_column}{Optional. Column name whose value should be used as the node label.}

\item{naming_style}{Naming convention to apply to the label from `label_column`. Options:
\itemize{
  \item{\code{"as_is"} (default): No transformation.}
  \item{\code{"snake"}: snake_case}
  \item{\code{"camel"}: camelCase}
  \item{\code{"pascal"}: PascalCase (TitleCase)}
  \item{\code{"upper"}: UPPER_CASE_WITH_UNDERSCORES}
  \item{\code{"lower"}: lowercase}
}}
}
\value{
A character vector of Cypher node creation statements.
}
\description{
Generates Cypher `CREATE` or `MERGE` statements for each row in a data frame,
optionally supporting dynamic labels and naming convention transformation.
}
