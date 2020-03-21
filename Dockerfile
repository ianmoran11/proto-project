FROM rocker/rstudio:3.6.2
RUN mkdir /home/rstudio/analysis_folder
RUN mkdir /renv
WORKDIR /analysis_folder
RUN install2.r --error --deps TRUE renv

