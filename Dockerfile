FROM fedora:22
MAINTAINER knoefel

#RUN dnf clean all && dnf update -y

RUN dnf install gcc file git libevent-devel python-devel sqlite-devel zeromq-devel libffi-devel openssl-devel systemd-python libsodium -y

RUN dnf install couchdb -y

RUN pip uninstall setuptools -y

#RUN useradd openp

COPY install.sh /home/openp/install.sh

RUN /home/openp/install.sh

EXPOSE 8080/tcp

