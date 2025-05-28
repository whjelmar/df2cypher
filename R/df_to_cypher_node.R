#' Convert a data frame to Cypher node creation statements
#'
#' Generates Cypher `CREATE` or `MERGE` statements for each row in a data frame,
#' optionally supporting dynamic labels and naming convention transformation.
#'
#' @param df A data frame where each row represents a node.
#' @param label A static label for all nodes (default: "Node").
#' @param id_column Column to use as the node identifier (used only for validation).
#' @param use_merge Logical. If TRUE, generates `MERGE` instead of `CREATE`. Defaults to FALSE.
#' @param label_column Optional. Column name whose value should be used as the node label.
#' @param naming_style Naming convention to apply to the label from `label_column`. Options:
#'   \itemize{
#'     \item{\code{"as_is"} (default): No transformation.}
#'     \item{\code{"snake"}: snake_case}
#'     \item{\code{"camel"}: camelCase}
#'     \item{\code{"pascal"}: PascalCase (TitleCase)}
#'     \item{\code{"upper"}: UPPER_CASE_WITH_UNDERSCORES}
#'     \item{\code{"lower"}: lowercase}
#'   }
#'
#' @return A character vector of Cypher node creation statements.
#' @export
#'
#' @examples
#' df <- data.frame(id = 1, name = "Walter", type = "admin")
#' df_to_cypher_node(df, label = "User", id_column = "id")
#'
#' # Using dynamic label
#' df_to_cypher_node(df, label_column = "type", naming_style = "pascal")
df_to_cypher_node <- function(df,
                              label = "Node",
                              id_column = "id",
                              use_merge = FALSE,
                              label_column = NULL,
                              naming_style = "as_is") {
  if (!is.null(id_column) && !id_column %in% names(df)) {
    stop("id_column not found in data frame")
  }
  
  purrr::pmap_chr(df, function(...) {
    row <- list(...)
    
    label_val <- if (!is.null(label_column) && label_column %in% names(row)) {
      apply_naming_convention(row[[label_column]], naming_style)
    } else {
      label
    }
    
    props <- glue::glue_collapse(
      purrr::imap_chr(row, function(val, key) {
        quoted_val <- if (is.numeric(val)) val else paste0('"', gsub('"', '\\"', val), '"')
        glue::glue("{key}: {quoted_val}")
      }),
      sep = ", "
    )
    
    glue::glue("{if (use_merge) 'MERGE' else 'CREATE'} (n:{label_val} {{ {props} }})")
  })
}
