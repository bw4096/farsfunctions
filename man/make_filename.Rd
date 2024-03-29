% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/fars_functions.r
\name{make_filename}
\alias{make_filename}
\title{Construct filename}
\usage{
make_filename(year)
}
\arguments{
\item{year}{A year, the function will try to convert it to an integer.}
}
\value{
The function returns the file name of the CSV FARS file for the given year. No path is added.
}
\description{
This function takes a year (any type with coversion to numeric)
and spells out the filename (no path) for the FARS file of that year.
}
\examples{
\dontrun{
make_filename(2013)
make_filename("2013")
}

}
