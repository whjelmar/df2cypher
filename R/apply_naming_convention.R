#' Apply naming conventions to a string value
#'
#' This utility transforms a string into a specified naming convention style.
#' Useful for generating dynamic Cypher node labels or relationship types from data frame columns.
#'
#' @param value A character string to be transformed.
#' @param style The naming convention to apply. Options include:
#'   \itemize{
#'     \item{\code{"as_is"}: Return the value unchanged.}
#'     \item{\code{"snake"}: Convert to snake_case (lowercase with underscores).}
#'     \item{\code{"camel"}: Convert to camelCase.}
#'     \item{\code{"pascal"}: Convert to PascalCase (TitleCase).}
#'     \item{\code{"upper"}: Convert to uppercase with underscores.}
#'     \item{\code{"lower"}: Convert to all lowercase with no separators.}
#'   }
#'
#' @return A string transformed according to the specified style.
#' @export
#'
#' @examples
#' apply_naming_convention("User Profile", "snake")
#' apply_naming_convention("access_token", "pascal")
#' apply_naming_convention("Super Admin", "camel")
apply_naming_convention <- function(value, style = "as_is") {
  if (is.na(value)) return("NA")
  value <- trimws(as.character(value))
  
  switch(style,
         snake = {
           value |>
             gsub("([a-z])([A-Z])", "\\1_\\2", x = _) |>
             gsub("[^A-Za-z0-9]+", "_", x = _) |>
             tolower()
         },
         camel = {
           parts <- strsplit(tolower(gsub("[^A-Za-z0-9]+", " ", value)), " ")[[1]]
           paste0(
             parts[1],
             paste0(
               toupper(substring(parts[-1], 1, 1)),
               substring(parts[-1], 2),
               collapse = ""
             )
           )
         },
         pascal = {
           parts <- strsplit(tolower(gsub("[^A-Za-z0-9]+", " ", value)), " ")[[1]]
           paste0(
             paste0(
               toupper(substring(parts, 1, 1)),
               substring(parts, 2)
             ),
             collapse = ""
           )
         },
         upper = toupper(gsub("[^A-Za-z0-9]+", "_", value)),
         lower = tolower(gsub("[^A-Za-z0-9]+", "", value)),
         value
  )
}
