# R-base Docker Image  

![Supported R](https://img.shields.io/badge/R-latest-blue?style=plastic&logo=R)
![Docker Platform](https://img.shields.io/badge/Docker-latest-blue?style=plastic&logo=docker)  

This repository contains a minimal R docker image with latest R version. The image is pre-built with support for spatial data packages though GDAL, GEOS and PROJ4. `ubuntu:focal` is used as the base image and thus any command that `ubuntu` can understand `goes` into `Dockerfile`.

To get started, you need to have [docker](https://docs.docker.com/engine/install/) installed and general knowledge about building images with docker.  

Set `jaysnm/r-base` as your `Base Image` to initialize build stage for subsequent instructions to create your `spatial-aware` docker image. Follow [this official guide](https://docs.docker.com/engine/reference/builder/#from) to understand how build instructions are specified in `Dockerfile`.

```
FROM jaysnm/r-base
 ....
 ....
CMD ...
```

## License  

The Dockerfile in this repository is licensed under [Creative Commons copyright](https://github.com/jaysnm/r-base/License).

## Contribution  

See [CONTRIBUTING.md](https://github.com/jaysnm/r-base/CONTRIBUTING.md) and [open an issue](https://github.com/jaysnm/r-base/issues)
