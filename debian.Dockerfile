FROM debian:bullseye-slim

LABEL maintainer "Jason Kinyua <jaysnmury@gmail.com>"
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive

# configure base image with fundamental utils
RUN apt-get update \ 
  && apt-get install -y --no-install-recommends apt-utils locales libssl-dev libcurl4-openssl-dev \
  apt-transport-https gnupg2 ca-certificates libfontconfig1-dev \
  && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen && update-locale ${LANG}

# configure system libs
RUN  echo "deb http://cloud.r-project.org/bin/linux/debian bullseye-cran40/" > /etc/apt/sources.list.d/cran.list \
  && gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys E19F5F87128899B192B1A2C2AD5F960A256A04AF \
  && gpg -a --export E19F5F87128899B192B1A2C2AD5F960A256A04AF | apt-key add - && apt-get update \
  && apt-get install -y --no-install-recommends pkg-config libgdal-dev libgeos-dev libgit2-dev \
  libproj-dev libxml2-dev libsqlite3-dev gdal-bin libudunits2-dev libcairo2-dev libcgal-dev \
  libglu1-mesa-dev libx11-dev libfreetype6-dev libxt-dev libharfbuzz-dev libfribidi-dev r-base r-base-dev \
  && echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), deps = T, download.file.method = "libcurl",' \
  'shiny.port = 3838, shiny.host = "0.0.0.0", shiny.launch.browser = FALSE)' >> /etc/R/Rprofile.site \
  && Rscript -e "install.packages(c('devtools','rmarkdown','knitr','raster','rgdal','shiny'))" \
  && Rscript -e "devtools::install_github(c('ramnathv/htmlwidgets','rstudio/htmltools','tidyverse/ggplot2'))" \
  && rm -rf /tmp/* /var/lib/apt/lists/* && mkdir -p /shiny/dashboard

# home directory
WORKDIR /shiny/dashboard

# create non-priviledged user
RUN useradd -d /shiny/dashboard -s /usr/sbin/nologin jovial

# Run as non-privileged user
USER jovial
EXPOSE 3838
CMD ["R"]
