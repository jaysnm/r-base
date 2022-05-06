FROM alpine
LABEL maintainer "Jason Kinyua <jaysnmury@gmail.com>"

# set environment vars
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

# install source build libs
RUN apk add --no-cache --update-cache --virtual wget curl make libtool libpq autoconf libxt-dev \ 
  automake pkgconfig g++ libgcc file libc-dev tzdata linux-headers curl-dev glu-dev tiff-dev \
  zlib-dev zstd-dev libjpeg-turbo-dev libpng-dev libwebp-dev expat-dev openjpeg-dev meson glib-dev

# compile udunits from source
RUN wget -P /usr/local https://artifacts.unidata.ucar.edu/repository/downloads-udunits/udunits-2.2.28.tar.gz \
  && cd /usr/local && tar -xf udunits-2.2.28.tar.gz && cd udunits-2.2.28 && ./configure && make && make install \
  && ldconfig -n /usr/local/lib && rm -rf /usr/local/udunits*

# compile imagemagic from source
RUN wget -P /usr/local https://github.com/ImageMagick/ImageMagick/archive/refs/tags/7.1.0-10.tar.gz \
  && cd /usr/local && tar -xf 7.1.0-10.tar.gz && cd ImageMagick-7.1.0-10 && ./configure && make && make install \
  && ldconfig -n /usr/local/lib && rm -rf /usr/local/*7.1.0-10*

# install requires system libraries
RUN apk add --no-cache --update-cache --virtual fribidi-dev libgit2-dev git cairo-dev \
  fontconfig-dev netcdf-dev libx11-dev sqlite-dev cargo libxml2-dev gawk texlive \
  freetype-dev texmf-dist gdal gdal-dev proj proj-dev geos-dev R R-dev R-doc \
  && apk add --no-cache cgal cgal-dev texmaker --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
  && ln -fs /usr/share/zoneinfo/Africa/Nairobi /etc/localtime 

# copy requirements file
COPY requirements.R /tmp/requirements.R

# install required packages
RUN Rscript /tmp/requirements.R && rm -rf /tmp/* && mkdir -p /shiny/dashboard

# home directory
WORKDIR /shiny/dashboard

# create non-priviledged user
RUN adduser -h /shiny/dashboard -S -s /usr/sbin/nologin jovial

# Run as non-privileged user
USER jovial
EXPOSE 3838
CMD ["R"]
