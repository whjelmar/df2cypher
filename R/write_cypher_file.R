#' Write Cypher Statements to a File
#'
#' @param cypher_lines A character vector of Cypher statements
#' @param file Path to output file (e.g., "output.cypher")
#' @param append Logical. Should output be appended to the file?
#'
#' @return The path to the written file (invisible)
#' @export
#'
#' @examples
#' write_cypher_file(c("CREATE (:Person {name: 'Alice'})"), "example.cypher")
write_cypher_file <- function(cypher_lines, file, append = FALSE) {
  writeLines(cypher_lines, con = file, sep = "\n", useBytes = TRUE)
  invisible(file)
}