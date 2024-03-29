#' Read FARS data
#'
#' This is a function that takes a filename of a data file as an argument,
#' reads the data from the file, and shapes the data into a data frame table.
#'
#' @param filename A character string giving the name of the data file to be loaded
#'
#'
#' @return This function returns a data frame table composed of the data from the
#' file specified by filename.
#'
#' @examples
#' \dontrun{
#' fars_read("accident_2013.csv.bz2")
#'}
#'
#'@import dplyr
#'@import readr
#'
#' @export
fars_read <- function(filename) {
  if(!file.exists(filename))
    stop("file '", filename, "' does not exist")
  data <- suppressMessages({
    readr::read_csv(filename, progress = FALSE)
  })
  dplyr::tbl_df(data)
}




#' Construct filename
#'
#' This function takes a year (any type with coversion to numeric)
#' and spells out the filename (no path) for the FARS file of that year.
#'
#' @param year A year, the function will try to convert it to an integer.
#'
#' @return The function returns the file name of the CSV FARS file for the given year. No path is added.
#'
#' @examples
#' \dontrun{
#' make_filename(2013)
#' make_filename("2013")
#' }
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  path = system.file("extdata", sprintf("accident_%d.csv.bz2", year), package = "farsfunctions")
  sprintf(path, year)
}


#' Read years
#'
#' Reads a FARS file, identified just by its year, as a tibble.
#'
#'
#' @param years A vector of years, or a single year. The function will try to find the correct
#' FARS file for each year in the current directory.
#'
#' @return The function returns the contents of the FARS files as a list of tibbles, one per year,
#'  with just month and year per accident, for all the years in the given years list. If a year has no
#'  data file, a warning is shown and NULL is returned.
#'
#' @examples
#' \dontrun{
#' fars_read_years(c(2013, 2014))
#' fars_read_years(2013)
#'}
#' @import dplyr
#' @importFrom  magrittr %>%
#' @export
fars_read_years <- function(years) {
  MONTH <- NULL
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH, year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}

#' FARS Data Summary
#'
#' Reads and summarize FARS data for the given years.
#'
#' FARS files should be on the working directory.
#'
#' @param years A vector of years, or a single year. The function will try to find the correct
#' FARS file for each year in the current directory.
#'
#' @return The function returns the summary of the FARS files for the given years,
#'  as number of accidents per month and year.
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(c(2013, 2014))
#' fars_summarize_years(2013)
#'}
#' @import tidyr
#' @importFrom  magrittr %>%
#'
#' @export
fars_summarize_years <- function(years) {
  year <- MONTH <- NULL
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year, MONTH) %>%
    dplyr::summarize(n = n()) %>%
    tidyr::spread(year, n)
}
#' Draw Map
#'
#' Reads and plot FARS data for the given state and year.
#'
#' The function check if the year data exists and the state (identified by its state number) exists in the year data.
#' Also sanitizes the location data (longitude and latitude). The function stops with error if the given state number
#' is incorrect (the state number is not in the FARS data files for the given year). A message is shown if no accidents
#' were registered for that year and state.
#'
#' FARS files should be on the working directory.
#'
#' @param state.num State, identified by its number.
#' @param year A year. The function will try to find the correct FARS file for the year
#'  in the current directory.
#'
#' @return The function plots the map of accidents in a state from the FARS files for the given year.
#'
#' @examples
#' \dontrun{
#' fars_map_state( 25, 2014 )
#' }
#' @import graphics
#' @import maps
#' @import dplyr
#'
#' @export
fars_map_state <- function(state.num, year) {
  STATE <- NULL
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}


