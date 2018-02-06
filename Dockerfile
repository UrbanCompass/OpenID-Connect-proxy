FROM centos:latest

LABEL authors="Michael Ward @devoperandi, Justin Mound"
# Based on https://github.com/mward29/openidc

RUN yum update -y && yum install -y \
  epel-release \
  httpd \
  mod_ssl \
  wget

# Install mod_auth_openidc, and its dependency, cjose
# From: https://github.com/zmartzone/mod_auth_openidc/releases/tag/v2.3.3:
# "...the libcjose 0.5.1 binaries that this module depends on are available from the release 2.3.0 "Assets" section"
RUN yum install -y https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.3.0/cjose-0.5.1-1.el7.centos.x86_64.rpm
RUN yum install -y https://github.com/zmartzone/mod_auth_openidc/releases/download/v2.3.3/mod_auth_openidc-2.3.3-1.el7.centos.x86_64.rpm

RUN yum clean all && rm -rf /var/cache/yum

# Mounting configuration files via Kubernetes' ConfigMap will make other files in /etc/httpd/conf.d/
# inaccessible. Instead, here we create /etc/httpd/conf.d.extras, which is where addidtional configuration
# files will be added via Kubernetes's ConfigMaps. (See deploy/deployment.yml spec: > containers: > volumeMounts).
# Without an existing config file, Apache would report an error and not start if the volumeMount wasn't present- which is useful
# for local workstation development of the docker image. (docker build ...; docker run ...)
WORKDIR /etc/httpd/conf.d
RUN mkdir ../conf.d.extras
RUN touch ../conf.d.extras/auth_openidc.conf
RUN ln -s ../conf.d.extras/auth_openidc.conf .

ADD httpd-foreground /usr/local/bin/

RUN chmod +x /usr/local/bin/httpd-foreground

EXPOSE 80

CMD ["httpd-foreground"]
