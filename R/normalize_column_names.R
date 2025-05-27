#' Normalize Column Names to Snake Case
#'
#' @param df A data.frame or tibble
#'
#' @return The same data frame with normalized column names
#' @export
#'
#' @examples
#' df <- tibble::tibble(Name = "Alice", `Start Date` = Sys.Date())
#' normalize_column_names(df)
normalize_column_names <- function(df) {
  stopifnot(is.data.frame(df))
  names(df) <- janitor::make_clean_names(names(df))
  df
}