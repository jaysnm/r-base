FROM alpine
LABEL maintainer "Jason Kinyua <jaysnmury@gmail.com>"
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
RUN apk update && apk add --no-cache --update-cache --virtual wget curl make libtool libpq autoconf \ 
  automake pkgconfig g++ libgcc sqlite-dev libc-dev tzdata linux-headers curl-dev imagemagick-dev \
  glu-dev tiff-dev zlib-dev zstd-dev libjpeg-turbo-dev libpng-dev libwebp-dev expat-dev openjpeg-dev \
  && apk add --no-cache --update-cache --virtual harfbuzz-dev fribidi-dev libgit2-dev git cairo-dev \
  fontconfig-dev netcdf-dev libx11 libx11-dev gawk graphicsmagick-dev file cargo libmagic libxml2-dev \
  texlive freetype-dev texmf-dist units gdal gdal-dev proj proj-dev geos-dev R R-dev R-doc \
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
