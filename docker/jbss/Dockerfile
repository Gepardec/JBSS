FROM fedora:31
MAINTAINER Erhard Siegl <erhard.siegl@gepardec.com>
RUN yum -y install java-1.8.0-openjdk.x86_64
RUN yum -y install unzip.x86_64 \
 && yum -y install perl-interpreter.x86_64 \
 && yum -y install procps \
 && yum -y install net-tools
ADD jboss7 /usr/local/bin/jbss
RUN mkdir /install /install/jboss /install/Downloads /install/config
ADD jbssrc /root/.jbssrc

