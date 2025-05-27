#' Preview Cypher Statements in Console
#'
#' @param cypher_lines A character vector of Cypher statements
#'
#' @return No return value. Prints to console.
#' @export
#'
#' @examples
#' preview_cypher(c("CREATE (:Person {name: 'Alice'})"))
preview_cypher <- function(cypher_lines) {
  cat(paste(cypher_lines, collapse = "\n"), "\n")
}