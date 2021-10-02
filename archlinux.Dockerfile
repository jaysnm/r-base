FROM archlinux

LABEL maintainer "Jason Kinyua <jaysnmury@gmail.com>"
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TZ=Africa/Nairobi

# configure locale and timezone libs
RUN pacman -Syu --noconfirm && pacman install -y fontconfig \ 
  && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen && localectl set-locale LANG=${LANG} 

# configure system libs
RUN pacman install -y gdal geos proj libgit2 libxml2 sqlite units cairo cgal glu freetype2 libxt harfbuzz fribidi r \
  && echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), deps = T, download.file.method = "libcurl",' \
  'shiny.port = 3838, shiny.host = "0.0.0.0", shiny.launch.browser = FALSE)' >> /etc/R/Rprofile.site \
  && Rscript -e "install.packages(c('devtools','rmarkdown','knitr','raster','rgdal','shiny'))" \
  && Rscript -e "devtools::install_github(c('ramnathv/htmlwidgets','rstudio/htmltools','tidyverse/ggplot2'))" \
  && rm -rf /tmp/* /var/lib/apt/lists/* \
  && mkdir -p /shiny/dashboard

# home directory
WORKDIR /shiny/dashboard

# create non-priviledged user
RUN useradd -d /shiny/dashboard -r -s /usr/sbin/nologin jovial

# Run as non-privileged user
USER jovial
EXPOSE 3838
CMD ["R"]
