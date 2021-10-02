FROM archlinux

LABEL maintainer "Jason Kinyua <jaysnmury@gmail.com>"
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

# configure locale and timezone libs
RUN pacman -Syu --noconfirm && pacman -S --noconfirm --needed freetype2 git base-devel \
  && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen \ 
  && echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && echo "root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && useradd --shell=/bin/false build && usermod -L build \
  && mkdir -p /shiny/dashboard && useradd -r -d /shiny/dashboard jovial \
  && chown jovial:jovial /shiny/dashboard \
  && mkdir -p /home/build/.gnupg &&  chown -Rf build:build /home/build

USER build

RUN git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin \
  && cd /tmp/yay-bin && makepkg -si --noconfirm --needed && cd / && rm -rf /tmp/yay-bin \
  && yay -Syu && yay -S --noconfirm fontconfig libcurl3-gnutls

ENV CRAN_PACKAGES c('devtools','rmarkdown','knitr','raster','rgdal','shiny')

# configure system libs
RUN yay -S --noconfirm --needed gdal gdal geos proj libgit2 libxml2 sqlite-utils \ 
  libspatialite-devel udunits units cairo cgal glu libxt harfbuzz fribidi r \
  && Rscript -e "install.packages(Sys.getenv('CRAN_PACKAGES'), repos='https://cloud.r-project.org/', deps=T, type='source')" \
  && Rscript -e "devtools::install_github(c('ramnathv/htmlwidgets','rstudio/htmltools','tidyverse/ggplot2'))" \
  && rm -rf /tmp/* /var/lib/apt/lists/*

# set working directory
WORKDIR /shiny/dashboard

# Run commands as unprivileged user
USER jovial

# Run as non-privileged user
USER jovial
EXPOSE 3838
CMD ["R"]
