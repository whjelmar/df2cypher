#' Convert a data frame into Cypher relationship statements
#'
#' @param df A data frame containing relationship data.
#' @param rel_type A string for static relationship type (ignored if `rel_type_column` is used).
#' @param from_col The column name containing the source node IDs.
#' @param to_col The column name containing the target node IDs.
#' @param direction Either "out" (default), "in", or "undirected".
#' @param use_merge Logical. If TRUE, uses MERGE instead of CREATE.
#' @param on_create Named list of properties to set on CREATE.
#' @param on_match Named list of properties to set on MATCH.
#' @param rel_type_column Optional column name containing dynamic relationship types.
#' @param naming_style Naming convention to apply to values in `rel_type_column`. One of:
#'   \itemize{
#'     \item{\code{"as_is"} (default): no change}
#'     \item{\code{"snake"}: snake_case}
#'     \item{\code{"camel"}: camelCase}
#'     \item{\code{"pascal"}: PascalCase}
#'     \item{\code{"upper"}: UPPER_CASE}
#'     \item{\code{"lower"}: lowercase}
#'   }
#'
#' @return A character vector of Cypher statements.
#' @export
df_to_cypher_relationship <- function(df,
                                      rel_type = "RELATES_TO",
                                      from_col,
                                      to_col,
                                      direction = "out",
                                      use_merge = FALSE,
                                      on_create = NULL,
                                      on_match = NULL,
                                      rel_type_column = NULL,
                                      naming_style = "as_is") {
  stopifnot(from_col %in% names(df), to_col %in% names(df))
  
  quote_value <- function(value) {
    if (is.numeric(value)) return(as.character(value))
    if (tolower(value) %in% c("true", "false")) return(tolower(value))
    glue::glue('"', gsub('"', '\\"', value), '"')
  }
  
  build_property_string <- function(props) {
    if (is.null(props)) return("")
    kv <- vapply(names(props), function(k) {
      glue::glue("{k}: {quote_value(props[[k]])}")
    }, FUN.VALUE = character(1))
    glue::glue_collapse(kv, sep = ", ")
  }
  
  statements <- mapply(function(from, to, row_idx) {
    from_id <- quote_value(from)
    to_id <- quote_value(to)
    
    rel_type_val <- if (!is.null(rel_type_column) && rel_type_column %in% names(df)) {
      apply_naming_convention(df[[rel_type_column]][row_idx], naming_style)
    } else {
      rel_type
    }
    
    rel_dir_template <- switch(
      direction,
      "out" = glue::glue("-[r:{rel_type_val}]->"),
      "in" = glue::glue("<-[r:{rel_type_val}]-"),
      "undirected" = glue::glue("-[r:{rel_type_val}]-"),
      stop("Invalid direction")
    )
    
    match_stmt <- glue::glue("MATCH (a), (b) WHERE a.id = {from_id} AND b.id = {to_id}")
    rel_stmt <- glue::glue("{if (use_merge) 'MERGE' else 'CREATE'} (a){rel_dir_template}(b)")
    create_clause <- if (!is.null(on_create)) glue::glue("ON CREATE SET {build_property_string(on_create)}") else ""
    match_clause <- if (!is.null(on_match)) glue::glue("ON MATCH SET {build_property_string(on_match)}") else ""
    
    if (direction == "undirected") {
      match_stmt_2 <- glue::glue("MATCH (a), (b) WHERE a.id = {to_id} AND b.id = {from_id}")
      rel_stmt_2 <- glue::glue("{if (use_merge) 'MERGE' else 'CREATE'} (a){rel_dir_template}(b)")
      c(
        glue::glue("{match_stmt} {rel_stmt} {create_clause} {match_clause}"),
        glue::glue("{match_stmt_2} {rel_stmt_2} {create_clause} {match_clause}")
      )
    } else {
      glue::glue("{match_stmt} {rel_stmt} {create_clause} {match_clause}")
    }
  },
  df[[from_col]], df[[to_col]], seq_len(nrow(df)),
  SIMPLIFY = FALSE)
  
  return(unlist(statements))
}
