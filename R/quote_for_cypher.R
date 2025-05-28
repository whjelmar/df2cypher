#' Quote values for Cypher property assignment
#'
#' Automatically converts R values into Cypher-compatible property types.
#'
#' @param value A single value (character, numeric, logical, or NA).
#'
#' @return A properly formatted Cypher-compatible string.
#' @export
#'
#' @examples
#' quote_for_cypher("hello world") # -> '"hello world"'
#' quote_for_cypher(42)            # -> '42'
#' quote_for_cypher(TRUE)          # -> 'true'
#' quote_for_cypher(NA)            # -> 'null'
quote_for_cypher <- function(value) {
  if (is.na(value) || is.null(value)) {
    return("null")
  }
  if (is.logical(value)) {
    return(tolower(as.character(value)))
  }
  if (is.numeric(value)) {
    return(as.character(value))
  }
  val <- gsub('"', '\\"', as.character(value))
  glue::glue('"{val}"')
}
