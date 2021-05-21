FROM ubuntu:20.04

LABEL maintainer="vasatanasov"

RUN DEBIAN_FRONTEND=noninteractive apt-get -qq update >/dev/null
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 >/dev/null
RUN apt-get clean

WORKDIR /var/www/html

COPY index.html index.html

EXPOSE 80

CMD [ "apachectl", "-D", "FOREGROUND"]