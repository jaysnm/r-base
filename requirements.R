#!/bin/Rscript

cran.packages <- c("devtools", "rmarkdown", "knitr", "raster", "rgdal", "shiny")
install.opts <- c("--no-help", "--no-html", "--no-docs")
build.opts <- c(
  "--no-resave-data",
  "--no-manual",
  "--no-build-vignettes",
  "--no-docs"
)

# https://github.com/r-lib/devtools/issues/2084
x <- file.path(R.home("doc"), "html")
if (!file.exists(x)) {
  dir.create(x, recursive = TRUE)
  file.copy(system.file("html/R.css", package = "stats"), x)
}

install.packages(
  cran.packages,
  repos = "https://cloud.r-project.org/",
  dependencies = TRUE,
  type = "source",
  INSTALL_opts = install.opts
)

devtools::install_github(
  c("ramnathv/htmlwidgets", "rstudio/htmltools", "tidyverse/ggplot2"),
  dependencies = TRUE,
  build_opts = build.opts,
  INSTALL_opts = install.opts
)
