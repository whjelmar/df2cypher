#' Convert a data frame to Cypher node creation statements
#'
#' @param df A data frame with node data
#' @param label The node label
#' @param id_column Column to use as the node identifier
#' @param use_merge Logical, whether to use MERGE instead of CREATE
#'
#' @return A character vector of Cypher statements
#' @export
df_to_cypher_node <- function(df, label = "Node", id_column = NULL, use_merge = FALSE) {
  if (!is.null(id_column) && !id_column %in% names(df)) {
    stop("id_column not found in data frame")
  }
  
  apply(df, 1, function(row) {
    row <- as.list(row)
    props <- glue::glue_collapse(
      purrr::imap_chr(row, function(val, key) {
        quoted_val <- if (is.numeric(val)) val else paste0('"', gsub('"', '\\"', val), '"')
        glue::glue("{key}: {quoted_val}")
      }),
      sep = ", "
    )
    
    id_clause <- if (!is.null(id_column)) {
      node_id <- row[[id_column]]
      quoted_id <- if (is.numeric(node_id)) node_id else paste0('"', gsub('"', '\\"', node_id), '"')
      glue::glue("n:{label} {{ {id_column}: {quoted_id} }}")
    } else {
      glue::glue("n:{label} {{ {props} }}")
    }
    
    verb <- if (use_merge) "MERGE" else "CREATE"
    glue::glue("{verb} ({id_clause})")
  })
}
