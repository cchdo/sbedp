FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntunoble

ENV HODLL=libwow64fex.dll
ENV WINEPREFIX=/.wine

RUN <<EOF 
    mkdir build &&
    cd build && 
    curl -L -O https://github.com/AndreRH/hangover/releases/download/hangover-11.0/hangover_11.0_ubuntu2404_noble_arm64.tar &&
    tar xf *.tar &&
    apt-get update &&
    apt-get install -y ./*.deb &&
    apt-get clean &&
    cd / && rm -rf /build
EOF

# The following also creates the /.wine diriectory when winetricks is run
# at the end of the step, we give the ownership of this wine directory to the abc user (from base image)
USER abc
RUN <<EOF
    sudo mkdir /.wine && sudo chown abc /.wine &&
    sudo mkdir /config/.cache && sudo chown abc /config/.cache &&
    sudo apt-get update &&
    sudo apt-get install -y winetricks xvfb &&
    xvfb-run winetricks -q vcrun2010 vcrun2012 &&
    sudo apt-get remove -y winetricks xvfb &&
    sudo apt-get autoremove -y &&
    sudo apt-get clean
EOF

ADD /graft /.wine

USER root

HEALTHCHECK --interval=1s CMD pidof Xvnc || exit 1
