#' Convert a data frame into Cypher relationship statements
#'
#' Generates Cypher `CREATE` or `MERGE` statements for relationships based on a data frame.
#' Supports directional and undirected relationships, optional attributes, and conditional
#' `ON CREATE` / `ON MATCH` clauses. Handles multiple target relationships per row and dynamic attributes.
#'
#' @param df A data frame containing relationship data.
#' @param rel_type A string indicating the type of relationship (e.g., "KNOWS").
#' @param from_col The column name containing the source node IDs.
#' @param to_col The column name containing the target node IDs.
#' @param direction Relationship direction: one of "out" (default), "in", or "undirected".
#' @param use_merge Logical. If TRUE, uses `MERGE` instead of `CREATE`.
#' @param on_create Optional named list of properties to set using `ON CREATE SET`.
#' @param on_match Optional named list of properties to set using `ON MATCH SET`.
#' @param from_multiple Logical. If TRUE, `from_col` values will be split into multiple relationships.
#' @param to_multiple Logical. If TRUE, `to_col` values will be split into multiple relationships.
#' @param delimiter Delimiter for splitting multiple target IDs (default: ";").
#' @param property_columns Optional vector of column names to include as relationship properties per row.
#'
#' @return A character vector of Cypher relationship statements.
#' @export
df_to_cypher_relationship <- function(df,
                                      rel_type = "RELATES_TO",
                                      from_col,
                                      to_col,
                                      direction = "out",
                                      use_merge = FALSE,
                                      on_create = NULL,
                                      on_match = NULL,
                                      from_multiple = FALSE,
                                      to_multiple = FALSE,
                                      delimiter = ";",
                                      property_columns = NULL) {
  stopifnot(from_col %in% names(df), to_col %in% names(df))
  stopifnot(!(from_multiple && to_multiple))
  
  rel_template <- switch(
    direction,
    "out" = "-[r:{rel_type}{props}]->",
    "in" = "<-[r:{rel_type}{props}]-",
    "undirected" = "-[r:{rel_type}{props}]-",
    stop("Invalid direction")
  )
  
  build_property_string <- function(props) {
    if (is.null(props) || length(props) == 0) return("")
    kv <- purrr::imap_chr(props, ~ glue::glue("{.y}: {quote_for_cypher(.x)}"))
    glue::glue(" {{{glue::glue_collapse(kv, sep = ', ')}}}")
  }
  
  build_clause <- function(clause, props) {
    if (is.null(props)) return("")
    glue::glue("{clause} SET {glue::glue_collapse(purrr::imap_chr(props, ~ glue::glue('r.{.y} = {quote_for_cypher(.x)}')), sep = ', ')}")
  }
  
  if (is.null(property_columns)) {
    property_columns <- setdiff(names(df), c(from_col, to_col))
  }
  
  all_statements <- purrr::map(seq_len(nrow(df)), function(i) {
    row <- df[i, , drop = FALSE]
    from_vals <- if (from_multiple) trimws(strsplit(as.character(row[[from_col]]), delimiter)[[1]]) else row[[from_col]]
    to_vals   <- if (to_multiple)   trimws(strsplit(as.character(row[[to_col]]), delimiter)[[1]])   else row[[to_col]]
    
    from_vals <- as.character(from_vals)
    to_vals   <- as.character(to_vals)
    
    combos <- expand.grid(from = from_vals, to = to_vals, stringsAsFactors = FALSE)
    
    purrr::pmap_chr(combos, function(from, to) {
      from_id <- quote_for_cypher(from)
      to_id   <- quote_for_cypher(to)
      
      match_stmt <- glue::glue("MATCH (a), (b) WHERE a.id = {from_id} AND b.id = {to_id}")
      
      row_props <- purrr::keep(row[property_columns], ~ !is.null(.x) && !is.na(.x))
      prop_string <- build_property_string(row_props)
      
      rel_stmt <- glue::glue("{if (use_merge) 'MERGE' else 'CREATE'} (a){glue::glue(rel_template, rel_type = rel_type, props = prop_string)}(b)")
      
      create_clause <- build_clause("ON CREATE", on_create)
      match_clause  <- build_clause("ON MATCH", on_match)
      
      glue::glue_collapse(c(match_stmt, rel_stmt, create_clause, match_clause), sep = " ")
    })
  })
  
  unlist(all_statements, use.names = FALSE)
}
