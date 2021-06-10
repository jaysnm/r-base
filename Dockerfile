FROM ubuntu:focal
LABEL maintainer "Jason Kinyua <J.M.Kinyua@cgiar.org>" unit "CIFOR-ICRAF SPACIAL" unit_head "Tor Vagen <T.VAGEN@cgiar.org>"
ARG GITHUB_PAT
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 GITHUB_PAT=$GITHUB_PAT
# Run commands as root
USER root
# create non-priviledged user
RUN useradd -d /shiny/dashboard -s /usr/sbin/nologin spacial
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \ 
	&& apt-get install -y --no-install-recommends \
	apt-utils tzdata locales nano wget ca-certificates \
	apt-transport-https gsfonts gnupg2 libfontconfig1-dev\
	&& echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
	&& locale-gen en_US.utf8 \
	&& /usr/sbin/update-locale LANG=en_US.UTF-8
# Configure local timezone
RUN ln -fs /usr/share/zoneinfo/Africa/Nairobi /etc/localtime \ 
	&& dpkg-reconfigure --frontend noninteractive tzdata \
	&& echo "deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/" > /etc/apt/sources.list.d/cran.list \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends r-base r-base-dev \
	&& echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"), deps = T, download.file.method = "libcurl",' \
	'shiny.port = 3838, shiny.host = "0.0.0.0", shiny.launch.browser = FALSE)' >> /etc/R/Rprofile.site \
	&& echo "deb http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu focal main  \n" \
	"deb-src http://ppa.launchpad.net/ubuntugis/ubuntugis-unstable/ubuntu focal main " \ 
	> /etc/apt/sources.list.d/ubuntugis.list \
	&& apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6B827C12C2D425E227EDCA75089EBE08314DF160 \
	&& apt-get update && \ 
	apt-get install -y --no-install-recommends libgdal-dev libgeos-dev libgit2-dev \
	libproj-dev libxml2-dev libsqlite3-dev gdal-bin libudunits2-dev libfontconfig1-dev \
	libcairo2-dev libcgal-dev libglu1-mesa-dev libx11-dev libfreetype6-dev libxt-dev libharfbuzz-dev libfribidi-dev\
	&& Rscript -e "install.packages(c('remotes','rmarkdown','knitr','raster','rgdal', 'shiny'))" \
	&& Rscript -e "remotes::install_github(c('ramnathv/htmlwidgets','rstudio/htmltools','tidyverse/ggplot2'))" \
	&& rm -rf /tmp/* /var/lib/apt/lists/* \
	&& mkdir -p /shiny/dashboard
# home directory
WORKDIR /shiny/dashboard
# run as non-privileged user
USER spacial
EXPOSE 3838
CMD ["R"]
