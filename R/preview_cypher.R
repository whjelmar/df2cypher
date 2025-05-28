#' Preview a sample of Cypher statements
#'
#' This function prints the first few Cypher statements from a character vector.
#' It is intended to provide a quick glance at the generated output, especially
#' useful when working with long lists of statements.
#'
#' @param statements A character vector of Cypher statements.
#' @param n An integer indicating how many statements to preview. Default is 5.
#'
#' @return Invisibly returns the previewed Cypher statements.
#' @export
#'
#' @importFrom utils head
#'
#' @examples
#' statements <- c(
#'   'CREATE (a:Person {id: 1})',
#'   'CREATE (b:Person {id: 2})',
#'   'CREATE (a)-[:FRIENDS_WITH]->(b)'
#' )
#' preview_cypher(statements)
preview_cypher <- function(statements, n = 5) {
  preview <- utils::head(statements, n = n)
  for (line in preview) {
    cat(line, "\n")
  }
  invisible(preview)
}
