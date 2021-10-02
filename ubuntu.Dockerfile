FROM ubuntu:focal

LABEL maintainer "Jason Kinyua <jaysnmury@gmail.com>"
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive

# configure base image with fundamental utils
RUN apt-get update && apt-get install -y --no-install-recommends apt-utils tzdata locales libssl-dev \
	apt-transport-https gnupg2 ca-certificates && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 && /usr/sbin/update-locale && dpkg-reconfigure tzdata

# Configure local timezone
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" > /etc/apt/sources.list.d/cran.list \
	&& gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
	&& gpg -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add - \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends r-base r-base-dev \
	&& echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), deps = T, download.file.method = "libcurl",' \
	'shiny.port = 3838, shiny.host = "0.0.0.0", shiny.launch.browser = FALSE)' >> /etc/R/Rprofile.site \
	&& echo "deb http://ppa.launchpad.net/ubuntugis/ppa/ubuntu focal main  \n" \
	"deb-src http://ppa.launchpad.net/ubuntugis/ppa/ubuntu focal main " \ 
	> /etc/apt/sources.list.d/ubuntugis.list \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6B827C12C2D425E227EDCA75089EBE08314DF160 \
	&& apt-get update && \ 
	apt-get install -y --no-install-recommends pkg-config libgdal-dev libgeos-dev libgit2-dev \
	libproj-dev libxml2-dev libsqlite3-dev gdal-bin libudunits2-dev libfontconfig1-dev libcurl4-openssl-dev \
	libcairo2-dev libcgal-dev libglu1-mesa-dev libx11-dev libfreetype6-dev libxt-dev libharfbuzz-dev libfribidi-dev\
	&& Rscript -e "install.packages(c('devtools','rmarkdown','knitr','raster','rgdal','shiny'))" \
	&& Rscript -e "devtools::install_github(c('ramnathv/htmlwidgets','rstudio/htmltools','tidyverse/ggplot2'))" \
	&& rm -rf /tmp/* /var/lib/apt/lists/* \
	&& mkdir -p /shiny/dashboard
# home directory
WORKDIR /shiny/dashboard
# create non-priviledged user
RUN useradd -d /shiny/dashboard -s /usr/sbin/nologin jovial
# Run as non-privileged user
USER jovial
EXPOSE 3838
CMD ["R"]
