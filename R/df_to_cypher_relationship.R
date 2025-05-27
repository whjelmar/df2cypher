#' Convert a data frame to Cypher CREATE statements for relationships
#'
#' @param df A data.frame or tibble representing relationships
#' @param from_label The label of the start node
#' @param to_label The label of the end node
#' @param rel_type The relationship type (e.g., "KNOWS")
#' @param from_col Column in df indicating the start node ID
#' @param to_col Column in df indicating the end node ID
#' @param props_cols Optional character vector of property columns for the relationship
#'
#' @return A character vector of Cypher CREATE statements for relationships
#' @export
#'
#' @examples
#' df <- tibble::tibble(from = 1, to = 2, since = 2020)
#' df_to_cypher_relationship(df, "Person", "Person", "KNOWS", "from", "to", "since")
df_to_cypher_relationship <- function(df, from_label, to_label, rel_type,
                                      from_col, to_col, props_cols = character()) {
  stopifnot(is.data.frame(df))
  stopifnot(from_col %in% names(df), to_col %in% names(df))
  
  apply(df, 1, function(row) {
    props <- if (length(props_cols) > 0) {
      purrr::imap_chr(row[props_cols], ~ glue::glue("{.y}: {jsonlite::toJSON(.x, auto_unbox = TRUE)}"))
    } else character()
    props_str <- glue::glue_collapse(props, sep = ", ")
    
    glue::glue(
      "MATCH (a:{from_label} {{ {from_col}: {jsonlite::toJSON(row[[from_col]], auto_unbox = TRUE)} }}), ",
      "(b:{to_label} {{ {to_col}: {jsonlite::toJSON(row[[to_col]], auto_unbox = TRUE)} }}) ",
      "CREATE (a)-[:{rel_type} {{{props_str}}}]->(b)"
    )
  }) |> unname()
}
