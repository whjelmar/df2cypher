#' Normalize column names to snake_case
#' @param df A data.frame or tibble
#' @return Dataframe with normalized column names
normalize_column_names <- function(df) {
  names(df) <- gsub("([a-z0-9])([A-Z])", "\\1_\\L\\2", names(df), perl = TRUE)
  names(df) <- tolower(names(df))
  df
}
