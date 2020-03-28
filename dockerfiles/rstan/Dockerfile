FROM rocker/geospatial
RUN apt-get update && \
  # software-properties-common contains add-apt-repository needed for ubuntugis
  # apt-get install -y gpg software-properties-common && \
  apt-get install -y gpg && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*  && \
  echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site 
RUN mkdir /home/rstudio/analysis_folder
RUN mkdir /renv
ENV RENV_VERSION 0.9.3-58
RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"
WORKDIR /analysis_folder

RUN sudo apt-get update && sudo apt-get install -y libreoffice
RUN R -e "install.packages('RcppParallel', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       apt-utils \
       ed \
       libnlopt-dev \
       clang \
       ccache \
       libxt-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/

# Set up environment
# Use correct Stan Makevars: https://github.com/stan-dev/rstan/wiki/Installing-RStan-on-Mac-or-Linux#prerequisite--c-toolchain-and-configuration
RUN mkdir -p $HOME/.R \
    # Add global configuration files
    # Docker chokes on memory issues when compiling with gcc, so use ccache and clang++ instead
    && echo '\n \
        \nCC=/usr/bin/ccache clang \
        \n \
        \n# Use clang++ and ccache \
        \nCXX=/usr/bin/ccache clang++ -Qunused-arguments  \
        \n \
        \n# Optimize building with clang \
        \nCXXFLAGS=-g -O3 -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2 -g -pedantic -g0 \
        \n \
        \n# Stan stuff \
        \nCXXFLAGS+=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -Wno-macro-redefined \
        \n' >> $HOME/.R/Makevars \
    # Make R use ccache correctly: http://dirk.eddelbuettel.com/blog/2017/11/27/
    && mkdir -p $HOME/.ccache/ \
    && echo "max_size = 5.0G \
        \nsloppiness = include_file_ctime \
        \nhash_dir = false \
        \n" >> $HOME/.ccache/ccache.conf \
    # Add configuration files for RStudio user
    && mkdir -p /home/rstudio/.R/ \
    && echo '\n \
        \n# Stan stuff \
        \nCXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function -Wno-macro-redefined \
        \n' >> /home/rstudio/.R/Makevars \
    && echo "rstan::rstan_options(auto_write = TRUE)\n" >> /home/rstudio/.Rprofile \
    && echo "options(mc.cores = parallel::detectCores())\n" >> /home/rstudio/.Rprofile

# Install Stan, rstan, rstanarm, brms, and friends
RUN install2.r --error --deps TRUE \
        rstan loo bayesplot rstanarm rstantools shinystan brms ggmcmc \
    && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
