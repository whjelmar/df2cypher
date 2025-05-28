#' Normalize column names to snake_case
#'
#' This function takes a data frame or tibble and normalizes its column names
#' to `snake_case`. It is useful for standardizing input data before further processing
#' or transformation steps, especially when dealing with external sources.
#'
#' @param df A data frame or tibble whose column names should be normalized.
#'
#' @return A data frame with updated `snake_case` column names.
#' @export
#'
#' @examples
#' df <- data.frame("First Name" = c("Alice", "Bob"), "Last.Name" = c("Smith", "Jones"))
#' normalize_column_names(df)
normalize_column_names <- function(df) {
  new_names <- names(df) |>
    gsub("[^[:alnum:]]+", "_", x = _) |>
    gsub("([a-z0-9])([A-Z])", "\\1_\\2", perl = TRUE, x = _) |>
    tolower() |>
    gsub("^_|_$", "", x = _) |>
    gsub("__+", "_", x = _)
  
  names(df) <- new_names
  df
}
