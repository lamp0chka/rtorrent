FROM        phusion/baseimage
MAINTAINER  Vitaly  <vitaly@vitaly.me>
ENV         HOME /root
RUN         /etc/my_init.d/00_regen_ssh_host_keys.sh
CMD         ["/sbin/my_init"]


RUN         apt-get -y update
RUN         apt-get -y install curl gzip wget unzip libxml2 libxml2-dev libgd2-xpm-dev libgeoip-dev libperl-dev libxslt1-dev libxslt1.1 libssl-dev make g++ pkg-config libcppunit-dev libcurl4-openssl-dev libncurses-dev subversion

# Installs libtorrent
#WORKDIR     /rtorrent
#RUN         (wget http://libtorrent.rakshasa.no/downloads/libtorrent-0.13.4.tar.gz) && \
            (tar -xzf libtorrent-0.13.4.tar.gz) && (rm libtorrent-0.13.4.tar.gz)
#WORKDIR     libtorrent-0.13.4
#RUN         (./configure) && (make) && (make install)

# Installs xmlrpc
#WORKDIR     /rtorrent
#RUN         svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable xmlrpc-c
#WORKDIR     xmlrpc-c
#RUN         (./configure --disable-cplusplus) && (make) && (make install)

# Installs rtorrent
#WORKDIR     /rtorrent
#RUN         (wget http://libtorrent.rakshasa.no/downloads/rtorrent-0.9.4.tar.gz) && \
            (tar -xzf rtorrent-0.9.4.tar.gz) && (rm rtorrent-0.9.4.tar.gz)
#WORKDIR     rtorrent-0.9.4
#RUN         (./configure --with-xmlrpc-c) && (make) && (make install) && (ldconfig)
RUN apt-get install -y rtorrent
# Install screen for rtorrent
RUN         apt-get -y install screen 

# Creates rtorrent as a service (using runit)
WORKDIR     /etc/service/rtorrent
ADD         ./run_rtorrent.sh /etc/service/rtorrent/run
RUN         chmod +x ./run

# Cleans up APT when done.
RUN         apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN	    mkdir /session
ADD         .rtorrent.rc /root/.rtorrent.rc

EXPOSE 5000
EXPOSE 63256
