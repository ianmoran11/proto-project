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
