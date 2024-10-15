FROM rockylinux:9
LABEL maintainer="robertreilly"

ENTRYPOINT ["tail", "-f",  "/dev/null"]

WORKDIR /ltest2

COPY . .

RUN cp *CA.crt /etc/pki/ca-trust/source/anchors
RUN update-ca-trust

ADD https://github.com/Kitware/CMake/releases/download/v3.25.3/cmake-3.25.3.tar.gz /ltest2
ADD https://dlcdn.apache.org/logging/log4cxx/1.2.0/apache-log4cxx-1.2.0.tar.gz /ltest2
RUN dnf install -y epel-release
RUN dnf install -y --enablerepo=devel gcc-c++ cmake gtest-devel redis-devel hiredis-devel openssl openssl-devel apr apr-devel apr-util apr-util-devel zip  \
  postgresql-devel fmt fmt-devel which yum-utils java

# now build liquibase
RUN rpm --import https://repo.liquibase.com/liquibase.asc
RUN yum-config-manager --add-repo https://repo.liquibase.com/repo-liquibase-com.repo
RUN yum install -y liquibase

