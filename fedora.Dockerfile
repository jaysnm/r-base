FROM fedora

LABEL maintainer "Jason Kinyua <jaysnmury@gmail.com>"

# configure locale and timezone libs
RUN dnf update -y && echo "%_install_langs all" > /etc/rpm/macros.image-language-conf \
  && dnf install -y openssl-devel glibc-common

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

# configure system libs
RUN dnf install -y gdal gdal-devel geos geos-devel libgit2-devel proj-devel libxml2-devel \ 
  libsqlite3x-devel udunits2-devel cairo-devel CGAL-devel freetype-devel harfbuzz-devel fribidi-devel R R-devel \
  && echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), deps = T, download.file.method = "libcurl",' \
  'shiny.port = 3838, shiny.host = "0.0.0.0", shiny.launch.browser = FALSE)' >> /etc/R/Rprofile.site \
  && Rscript -e "install.packages(c('devtools','rmarkdown','knitr','raster','rgdal','shiny'))" \
  && Rscript -e "devtools::install_github(c('ramnathv/htmlwidgets','rstudio/htmltools','tidyverse/ggplot2'))" \
  && rm -rf /tmp/* /var/lib/apt/lists/* && mkdir -p /shiny/dashboard

# home directory
WORKDIR /shiny/dashboard

# create non-priviledged user
RUN useradd -d /shiny/dashboard -r -s /usr/sbin/nologin jovial

# Run as non-privileged user
USER jovial
EXPOSE 3838
CMD ["R"]
