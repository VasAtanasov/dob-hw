FROM maven:3.8.1-amazoncorretto-11

RUN yum install -y libXext.x86_64 libXrender.x86_64 libXtst.x86_64 \
  && rm -rf /var/cache/yum/* \
  && yum clean all

RUN mkdir -p /autodb/db \
  RUN mkdri -p /scripts

COPY pom.xml /autodb/db
COPY scripts /autodb/db/scripts
COPY changelog /autodb/db/changelog
COPY update.sh /scripts

RUN chmod a+x /scripts/*.sh

CMD ["bash", "/scripts/update.sh"]
