# syntax=docker/dockerfile:1.3-labs
FROM ubuntu:lunar

RUN apt-get update \
 # As per https://github.com/ShephedProject/shepherd/wiki/Installation#PerlDependencies
 && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libxml-simple-perl \
    libalgorithm-diff-perl \
    liblocale-codes-perl \
    libdata-dumper-simple-perl \
    libdate-manip-perl \
    libobject-tiny-perl \
    liblist-compare-perl \
    libdatetime-format-strptime-perl \
    libhtml-parser-perl \
    libxml-dom-perl \
    libarchive-zip-perl \
    libio-string-perl \
    xmltv \
    libdbi-perl \
    libdbd-mysql-perl \
    libsort-versions-perl \
    libjson-perl \
    libjson-xs-perl \
    expect \
    patch \
 && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 999 shepherd \
 && useradd -u 999 -g shepherd -m -s /bin/bash shepherd \
 && ln -sfv /usr/share/zoneinfo/Australia/Sydney /etc/localtime

USER shepherd

COPY shepherd shepherd.expect /

# Workaround as per https://github.com/ShephedProject/shepherd/issues/31
USER root
RUN patch -Np2 -i - <<"EOF"
diff --git a/applications/shepherd b/applications/shepherd
index 33d0144..df36775 100755
--- a/applications/shepherd
+++ b/applications/shepherd
@@ -3119,6 +3119,7 @@ sub my_die {
 	    } else {
 		    print STDERR join("",@rest)
 	    }
+        CORE::die;
     } else {
 		printf STDERR "\nDIE: line %d in file %s\n",$line,$file;
 	    if ($arg) {
EOF
USER shepherd
RUN install -Dm755 /shepherd /home/shepherd/.shepherd/applications/shepherd/shepherd \
 && cat > /home/shepherd/.shepherd/shepherd.conf <<"EOF"
$region = undef;
$pref_title_source = undef;
$want_paytv_channels = undef;
$sysid = '1678963934.11';
$last_successful_run = undef;
$last_successful_run_data = undef;
$last_successful_runs = undef;
$last_successful_refresh = undef;
$sources = [
             'https://raw.githubusercontent.com/ShephedProject/shepherd/release/'
           ];
$components = {
                'shepherd' => {
                                'admin_status' => 'updated from v0 to v1.9.18',
                                'updated' => 1678963936,
                                'ver' => '1.9.18',
                                'type' => 'application',
                                'ready' => 1,
                                'config' => {
                                              'option_ready' => '--version',
                                              'desc' => 'Wrapper for various Aussie TV guide data grabbers'
                                            },
                                'source' => 'https://raw.githubusercontent.com/ShephedProject/shepherd/release/'
                              }
              };
$components_pending_install = {};
$pending_messages = {};
EOF

RUN /shepherd.expect \
 # Use the full path to avoid a warning
 && /home/shepherd/.shepherd/applications/shepherd/shepherd --component-set augment_timezone:timeoffset=Auto \
 && /home/shepherd/.shepherd/applications/shepherd/shepherd --component-set shepherd:output=output.xmltv:nolog:noautorefresh

# Note 9Gem HD still broken so using just 9Gem for now

ENTRYPOINT ["/home/shepherd/.shepherd/applications/shepherd/shepherd"]

