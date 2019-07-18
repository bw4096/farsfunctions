# farsfunctions

Travis Badge
<!-- badges: start -->
[![Build Status](https://travis-ci.com/bw4096/farsfunctions.svg?branch=master)](https://travis-ci.com/bw4096/farsfunctions)
<!-- badges: end -->

## Package 

This R Package was created as an educational project for a R Building Packages course

## Installation

You can install the farsfunctions package using:

``` r
install_github('bw4096/farsfunctions')
library(farsfunctions)
```

## Example

This is a basic example which shows you how to obtain a map of fatal accidents in state ID#25 for the year 2014:

``` r
library(farsfunctions)
## basic example code
fars_map_state(25, 2014)
```

