FROM rocker/r-ver:4.2.2

ARG openjdk_version="17"
USER root

# We will install R and packages using instructions from https://cloud.r-project.org/
# Should be installed into /usr/lib/R/site-library
RUN apt-get update -y \
    && apt-get -y upgrade \
    && apt-get -y dist-upgrade \
    && apt-get install -y --no-install-recommends "openjdk-${openjdk_version}-jdk-headless" ca-certificates-java \
    software-properties-common dirmngr build-essential curl wget libssl-dev libcurl4-openssl-dev libgdal-dev libre2-dev \
    apt-utils libudunits2-dev cmake lsb-release gpg-agent libssh-dev \
    && apt autoremove -y \
    && apt-get -y clean all \
    && rm -rf /var/lib/apt/lists/*

# Installing sssd-tools (required for authentication)
RUN apt update && \
    apt-get -y clean all && \
    apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y dist-upgrade && \
    apt-get -y install openssh-client && \
    apt-get -y install sssd-tools && \
    apt-get -y install wget && \
    apt-get -y install cron

ENV S6_VERSION=v2.1.0.2
ENV RSTUDIO_VERSION=2022.07.2+576
ENV DEFAULT_USER=rstudio
ENV PANDOC_VERSION=default
ENV QUARTO_VERSION=default

RUN /rocker_scripts/install_rstudio.sh && \
    /rocker_scripts/install_pandoc.sh && \
    /rocker_scripts/install_quarto.sh && \
    #/rocker_scripts/install_texlive.sh && \
    /rocker_scripts/install_tensorflow.sh && \
    /rocker_scripts/install_tidyverse.sh && \
    apt-get -y update && \
    # installing texlive via apt instead, the built in install_texlive doesnt supply everything
    apt-get -y install texlive-full && \
    # alien is a helper to install oracle instantclient
    apt-get install -y --no-install-recommends alien && \
    # installing yad (yet another dialog)
    apt-get -y install yad && \
    apt-get install -y iputils-ping && \
    apt-get install -y --no-install-recommends libaio1

ENV R_HOME /usr/local/lib/R
ENV R_LIBS_USER /usr/local/lib/R/library

# Change default R repo
COPY Rprofile.site /etc/R/Rprofile.site
COPY Rprofile.site /usr/local/lib/R/etc/Rprofile.site

# Setting up environment variables for oracle and R
ENV OCI_INC=/usr/include/oracle/21/client64
ENV OCI_LIB=/usr/lib/oracle/21/client64/lib
ENV ORACLE_HOME=/usr/lib/oracle/21/client64
ENV TNS_ADMIN=/usr/lib/oracle/21/client64/lib/network
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/oracle/21/client64/lib

# Downloading oracle instant-client components and saving to /tmp
RUN wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-basic-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-devel-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-sqlplus-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-odbc-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-jdbc-21.6.0.0.0-1.x86_64.rpm -P /tmp/ && \
    wget https://download.oracle.com/otn_software/linux/instantclient/216000/oracle-instantclient-tools-21.6.0.0.0-1.x86_64.rpm -P /tmp/

# Installing oracle-instantclient components using alien
RUN alien -i /tmp/oracle-instantclient-basic-21.6.0.0.0-1.x86_64.rpm && \
    alien -i /tmp/oracle-instantclient-devel-21.6.0.0.0-1.x86_64.rpm && \
    alien -i /tmp/oracle-instantclient-sqlplus-21.6.0.0.0-1.x86_64.rpm && \
    alien -i /tmp/oracle-instantclient-odbc-21.6.0.0.0-1.x86_64.rpm && \
    alien -i /tmp/oracle-instantclient-jdbc-21.6.0.0.0-1.x86_64.rpm && \
    alien -i /tmp/oracle-instantclient-tools-21.6.0.0.0-1.x86_64.rpm && \
    rm -rf /tmp/oracle-instantclient-*

# https://cran.r-project.org/web/packages/arrow/vignettes/install.html
ENV NOT_CRAN true
ENV ARROW_GCS=ON

RUN apt-get update -y && \
    # vim support
    apt-get -y install vim && \
    # Installing bsdmainutils, helped solve colrm message after every command in the terminal
    apt-get install -y bsdmainutils && \
    apt autoremove -y && \
    apt-get -y clean all && \
    rm -rf /var/lib/apt/lists/*

COPY jwsacruncher-2.2.4.zip /tmp/jwsacruncher-2.2.4.zip

# Setup R java support and install R packages that are not available as Ubuntu packages
RUN R CMD javareconf -e && \
    R -e "install.packages('renv', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('ROracle', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('RTextTools', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('configr', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('SSBtools', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('RegSDC', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('oysteR', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('writexl', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('concaveman', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('cppRouting', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('rjwsacruncher', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('klassR', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('antiword', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('textshape', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('striprtf', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('textreadr', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('terra', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('raster', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('leaflet', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('languageserver', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('sotkanet', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('ggiraph', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('dcmodify', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('simputation', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('arrow', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "remotes::install_github('r-barnes/dggridR', vignette=TRUE)" && \
    R -e "remotes::install_github('statisticsnorway/Kostra')" && \
    R -e "remotes::install_github('statisticsnorway/SdcForetakPerson')" && \
    R -e "remotes::install_github('statisticsnorway/struktuR')" && \
    R -e "install.packages('dotenv', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('PriceIndices', dependencies=TRUE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    R -e "install.packages('sfarrow', dependencies=FALSE, repos='https://packagemanager.rstudio.com/cran/latest')" && \
    rm -rf /tmp/downloaded_packages/ /tmp/*.rds && \
    # Doesn t work with Java11 - use a custom one
    unzip /tmp/jwsacruncher-2.2.4.zip -d /opt && rm -f /tmp/jwsacruncher-2.2.4.zip && \
    # Create a symlink at /usr/bin so users can call jwsacruncher from anywhere
    ln -s /opt/jwsacruncher-2.2.4/bin/jwsacruncher /usr/bin/jwsacruncher

# add tnsnames.ora to oracle path
RUN ln -s /ssb/share/etc/tnsnames.ora /usr/lib/oracle/21/client64/lib/network/tnsnames.ora

# symlink to /ssb/share/etc/stamme_variabel
RUN ln -s /ssb/share/etc/stamme_variabel /etc/profile.d/stamme_variabel

RUN mkdir -p /usr/local/share/etc/
COPY bashrc.felles /usr/local/share/etc/bashrc.felles

# Set FELLES environment variable
ENV FELLES=/ssb/bruker/felles

# Set localtime to Europe/Oslo
ENV TZ=Europe/Oslo
RUN rm -f /etc/localtime && \
    ln -s /usr/share/zoneinfo/Europe/Oslo /etc/localtime

# adding a custom bashrc with git branch in PS1
COPY default-bashrc /etc/skel/.bashrc

COPY check-git-config.bash /usr/local/bin/check-git-config.sh
RUN chmod +x /usr/local/bin/check-git-config.sh

# Install ssb-gitconfig.py script
RUN wget -O /usr/local/bin/ssb-gitconfig.py https://raw.githubusercontent.com/statisticsnorway/kvakk-git-tools/main/ssb-gitconfig/ssb-gitconfig.py
RUN chmod +x /usr/local/bin/ssb-gitconfig.py

# Appends ssh-rsa as the accepted algorithm to /etc/ssh/ssh_config
# using printf instead of echo -e because the option -e gets appended to the file,
# and i could not find a working solution other than printf or copying the file from repo to image
RUN printf "    PubkeyAcceptedAlgorithms +ssh-rsa\n    HostkeyAlgorithms +ssh-rsa" >> /etc/ssh/ssh_config

# Use proxy for https connections, this must happen last
ENV https_proxy=http://proxy.ssb.no:3128
ENV no_proxy=nexus.ssb.no,git-adm.ssb.no,i.test.ssb.no,i.ssb.no,data.ssb.no,github.com,api.github.com,codeload.github.com

# Custom startup script which calls the original startup script /init at the end
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 8787

CMD ["/start.sh"]