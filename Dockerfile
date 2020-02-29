FROM ubuntu:devel

RUN apt-get update \
 # As per https://github.com/ShephedProject/shepherd/wiki/Installation#PerlDependencies
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    software-properties-common \
 # Contains packages that have been removed from the latest Ubuntu releases
 && add-apt-repository -y ppa:willat8/shepherd \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libxml-simple-perl \
    libalgorithm-diff-perl \
    libgetopt-mixed-perl \
    libdata-dumper-simple-perl \
    libdate-manip-perl \
    liblist-compare-perl \
    libdatetime-format-strptime-perl \
    libhtml-parser-perl \
    libxml-dom-perl \
    libgd-gd2-perl \
    libarchive-zip-perl \
    libio-string-perl \
    xmltv \
    libdbi-perl \
    libsort-versions-perl \
    libjson-perl \
    libobject-tiny-perl \
    libjson-maybexs-perl \
    libdbd-mysql-perl \
    liblocale-codes-perl \
    expect \
    cron \
    dc \
 && rm -rf /var/lib/apt/lists/*

RUN groupadd shepherd \
 && useradd -g shepherd -m -s /bin/bash shepherd \
 && ln -sfv /usr/share/zoneinfo/Australia/Sydney /etc/localtime \
 # Set suid on cron so it can be started by the shepherd user
 && chmod u+s /usr/sbin/cron \
 && install -dm 755 -o shepherd -g shepherd /shepherd_output

VOLUME /shepherd_output

USER shepherd

COPY shepherd shepherd.expect entrypoint.sh /

RUN /shepherd.expect \
 # Use the full path to avoid a warning
 && /home/shepherd/.shepherd/applications/shepherd/shepherd --component-set augment_timezone:timeoffset=Auto \
 && /home/shepherd/.shepherd/applications/shepherd/shepherd --component-set shepherd:output=/shepherd_output/output.xmltv:nolog:noautorefresh

ENTRYPOINT ["/entrypoint.sh"]

