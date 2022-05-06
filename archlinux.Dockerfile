FROM archlinux

LABEL maintainer "Jason Kinyua <jaysnmury@gmail.com>"
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 R_REMOTES_NO_ERRORS_FROM_WARNINGS=true

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
  && yay -Syu --noconfirm && yay -S --noconfirm --needed fontconfig libcurl3-gnutls

# configure system libs
RUN yay -S --noconfirm --needed gdal gdal geos proj libgit2 libxml2 libspatialite \ 
  udunits units texlive-core cairo cgal glu libxt harfbuzz fribidi rust imagemagick r

COPY requirements.R /tmp/requirements.R

RUN mkdir -p $HOME/.R/lib && export R_REMOTES_NO_ERRORS_FROM_WARNINGS=true && export R_LIBS_USER=$HOME/.R/lib && Rscript /tmp/requirements.R

USER root

RUN rm -rf /tmp/*

# set working directory
WORKDIR /shiny/dashboard

# Run commands as unprivileged user
USER jovial

# Run as non-privileged user
USER jovial
EXPOSE 3838
CMD ["R"]
