FROM fedora:22
MAINTAINER knoefel

# Dont wanna run updates as unclear which versions openprocurement needs
#RUN dnf clean all && dnf update -y

# Install prereqs PLUS  libsodium and nginx
RUN dnf install gcc file git libevent-devel python-devel sqlite-devel zeromq-devel libffi-devel openssl-devel systemd-python libsodium couchdb nginx -y

# Uninstall setuptools as buildout needs older version and will take care of it
RUN pip install --upgrade setuptools 

COPY nginx.conf /etc/nginx/nginx.conf

# install.sh is installation script for openprocurement
COPY install.sh /home/openp/install.sh
RUN /home/openp/install.sh

# wrapper.sh starts NGINX, circusd and chausette
COPY wrapper.sh  /home/openp/wrapper.sh

# Could not figure out how to change api port and host from localhost:8080 
# thus we use nginx to forward 5000 to 8080 and map external 8080 to 5000
# e.g. docker run -p 8080:5000
EXPOSE 5000

CMD /home/openp/wrapper.sh


