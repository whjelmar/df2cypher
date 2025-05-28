#' Write Cypher statements to a file
#'
#' This function writes a character vector of Cypher statements to a specified file.
#' It ensures each statement is written on its own line. Useful for exporting
#' Cypher code to be used in Neo4j import scripts or for auditing purposes.
#'
#' @param statements A character vector of Cypher statements.
#' @param file A string specifying the path to the output file.
#' @param append Logical. If TRUE, the statements will be appended to the file.
#'   If FALSE (default), the file will be overwritten.
#'
#' @return Invisibly returns the path to the file.
#' @export
#'
#' @examples
#' statements <- c(
#'   'CREATE (a:Person {id: 1})',
#'   'CREATE (b:Person {id: 2})',
#'   'CREATE (a)-[:FRIENDS_WITH]->(b)'
#' )
#' tmp <- tempfile(fileext = ".cypher")
#' write_cypher_file(statements, tmp)
#' readLines(tmp)
write_cypher_file  <- function(statements, file, append = FALSE) {
  writeLines(text = statements, con = file, sep = "\n", useBytes = TRUE)
  if (!append) {
    message("Wrote ", length(statements), " statements to: ", file)
  }
  invisible(file)
}
