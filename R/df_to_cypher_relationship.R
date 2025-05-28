#' Convert a data frame into Cypher relationship statements
#'
#' Generates Cypher `CREATE` or `MERGE` statements for relationships based on a data frame.
#' Supports directional and undirected relationships, optional attributes, and conditional
#' `ON CREATE` / `ON MATCH` clauses. Uses a quoting function to handle automatic type conversion.
#'
#' @param df A data frame containing relationship data.
#' @param rel_type A string indicating the type of relationship (e.g., "KNOWS").
#' @param from_col The column name containing the source node IDs.
#' @param to_col The column name containing the target node IDs.
#' @param direction Relationship direction: one of "out" (default), "in", or "undirected".
#' @param use_merge Logical. If TRUE, uses `MERGE` instead of `CREATE`.
#' @param on_create Optional named list of properties to set using `ON CREATE SET`.
#' @param on_match Optional named list of properties to set using `ON MATCH SET`.
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
                                      on_match = NULL) {
  stopifnot(from_col %in% names(df), to_col %in% names(df))
  
  build_property_string <- function(props) {
    if (is.null(props)) return("")
    kv <- vapply(names(props), function(k) {
      glue::glue("{k}: {quote_for_cypher(props[[k]])}")
    }, FUN.VALUE = character(1))
    glue::glue_collapse(kv, sep = ", ")
  }
  
  rel_dir_template <- switch(
    direction,
    "out" = "-[r:{rel_type}]->",
    "in" = "<-[r:{rel_type}]-",
    "undirected" = "-[r:{rel_type}]-",
    stop("Invalid direction")
  )
  
  statements <- switch(
    direction,
    
    "out" = mapply(function(from, to) {
      match_stmt <- glue::glue("MATCH (a), (b) WHERE a.id = {quote_for_cypher(from)} AND b.id = {quote_for_cypher(to)}")
      rel_stmt <- glue::glue("{if (use_merge) 'MERGE' else 'CREATE'} (a){glue::glue(rel_dir_template)}(b)")
      create_clause <- if (!is.null(on_create)) glue::glue("ON CREATE SET {build_property_string(on_create)}") else ""
      match_clause <- if (!is.null(on_match)) glue::glue("ON MATCH SET {build_property_string(on_match)}") else ""
      glue::glue("{match_stmt} {rel_stmt} {create_clause} {match_clause}")
    }, df[[from_col]], df[[to_col]], SIMPLIFY = TRUE, USE.NAMES = FALSE),
    
    "in" = mapply(function(from, to) {
      match_stmt <- glue::glue("MATCH (a), (b) WHERE a.id = {quote_for_cypher(from)} AND b.id = {quote_for_cypher(to)}")
      rel_stmt <- glue::glue("{if (use_merge) 'MERGE' else 'CREATE'} (a){glue::glue(rel_dir_template)}(b)")
      create_clause <- if (!is.null(on_create)) glue::glue("ON CREATE SET {build_property_string(on_create)}") else ""
      match_clause <- if (!is.null(on_match)) glue::glue("ON MATCH SET {build_property_string(on_match)}") else ""
      glue::glue("{match_stmt} {rel_stmt} {create_clause} {match_clause}")
    }, df[[from_col]], df[[to_col]], SIMPLIFY = TRUE, USE.NAMES = FALSE),
    
    "undirected" = unlist(mapply(function(from, to) {
      from_id <- quote_for_cypher(from)
      to_id <- quote_for_cypher(to)
      
      match_stmt_1 <- glue::glue("MATCH (a), (b) WHERE a.id = {from_id} AND b.id = {to_id}")
      rel_stmt_1 <- glue::glue("{if (use_merge) 'MERGE' else 'CREATE'} (a){glue::glue(rel_dir_template)}(b)")
      
      match_stmt_2 <- glue::glue("MATCH (a), (b) WHERE a.id = {to_id} AND b.id = {from_id}")
      rel_stmt_2 <- glue::glue("{if (use_merge) 'MERGE' else 'CREATE'} (a){glue::glue(rel_dir_template)}(b)")
      
      create_clause <- if (!is.null(on_create)) glue::glue("ON CREATE SET {build_property_string(on_create)}") else ""
      match_clause <- if (!is.null(on_match)) glue::glue("ON MATCH SET {build_property_string(on_match)}") else ""
      
      c(
        glue::glue("{match_stmt_1} {rel_stmt_1} {create_clause} {match_clause}"),
        glue::glue("{match_stmt_2} {rel_stmt_2} {create_clause} {match_clause}")
      )
    }, df[[from_col]], df[[to_col]], SIMPLIFY = FALSE), use.names = FALSE)
  )
  
  return(statements)
}
