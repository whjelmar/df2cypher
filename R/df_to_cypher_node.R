#' Convert a data frame to Cypher CREATE statements for nodes
#'
#' @param df A data.frame or tibble representing nodes
#' @param label A character string specifying the label for the nodes
#' @param id_column The column name used as a unique identifier for each node
#'
#' @return A character vector of Cypher CREATE statements
#' @export
#'
#' @examples
#' df <- tibble::tibble(id = 1:2, name = c("Alice", "Bob"))
#' df_to_cypher_node(df, label = "Person", id_column = "id")
df_to_cypher_node <- function(df, label, id_column) {
  stopifnot(is.data.frame(df))
  stopifnot(id_column %in% names(df))
  
  apply(df, 1, function(row) {
    props <- purrr::imap_chr(row, ~ glue::glue("{.y}: {jsonlite::toJSON(.x, auto_unbox = TRUE)}"))
    props_str <- glue::glue_collapse(props, sep = ", ")
    glue::glue("CREATE (:{label} {{{props_str}}})")
  }) |> unname()
}

