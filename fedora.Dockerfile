FROM fedora

LABEL maintainer "Jason Kinyua <jaysnmury@gmail.com>"

ENV LIB123=TRUE

# configure locale and timezone libs
RUN dnf update -y && echo "%_install_langs all" > /etc/rpm/macros.image-language-conf \
  && dnf install -y openssl-devel libcurl-devel glibc-common langpacks-en glibc-langpack-en 

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 R_REMOTES_NO_ERRORS_FROM_WARNINGS=true

# configure system libs
RUN dnf install -y gdal gdal-devel geos geos-devel libgit2-devel proj-devel libxml2-devel \ 
  libsqlite3x-devel udunits2-devel cairo-devel CGAL-devel freetype-devel harfbuzz-devel netcdf-devel \ 
  fribidi-devel ImageMagick-c++-devel libX11-devel cargo R R-devel && rm -rf /var/lib/apt/lists/*

COPY requirements.R /tmp/requirements.R

RUN Rscript /tmp/requirements.R && rm -rf /tmp/* && mkdir -p /shiny/dashboard

# home directory
WORKDIR /shiny/dashboard

# create non-priviledged user
RUN useradd -d /shiny/dashboard -r -s /usr/sbin/nologin jovial

# Run as non-privileged user
USER jovial
EXPOSE 3838
CMD ["R"]
