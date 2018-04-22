FROM fedora:22
MAINTAINER knoefel

#RUN dnf clean all && dnf update -y

RUN dnf install gcc file git libevent-devel python-devel sqlite-devel zeromq-devel libffi-devel openssl-devel systemd-python libsodium -y

RUN dnf install couchdb -y

RUN pip uninstall setuptools -y

RUN dnf install nginx -y
#RUN useradd openp

COPY nginx.conf /etc/nginx/nginx.conf

#RUN nginx

COPY install.sh /home/openp/install.sh

RUN /home/openp/install.sh

#RUN systemctl enable nginx.service
#RUN systemctl start nginx.service

COPY wrapper.sh  /home/openp/wrapper.sh

EXPOSE 5000

CMD /home/openp/wrapper.sh


