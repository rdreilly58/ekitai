FROM rockylinux:8
LABEL maintainer="robertreilly"
ENTRYPOINT ["tail", "-f",  "/dev/null"]
WORKDIR /ltest2
COPY . .

RUN cp *CA.crt /etc/pki/ca-trust/source/anchors
RUN update-ca-trust

RUN sed -i 's/#installonly_limit=5/installonly_limit=3/' /etc/dnf/dnf.conf
RUN sed -i 's/#clean_requirements_on_remove=True/clean_requirements_on_remove=True/' /etc/dnf/dnf.conf
RUN sed -i 's/#fastestmirror=True/fastestmirror=True/' /etc/dnf/dnf.conf
RUN sed -i 's/#max_parallel_downloads=5/max_parallel_downloads=3/' /etc/dnf/dnf.conf
RUN sed -i 's/#deltarpm=True/deltarpm=True/' /etc/dnf/dnf.conf
RUN sed -i 's/#minrate=10/minrate=100/' /etc/dnf/dnf.conf
RUN sed -i 's/#timeout=60/timeout=60/' /etc/dnf/dnf.conf
RUN sed -i 's/retry=10/retry=10/' /etc/dnf/dnf.conf

ADD https://github.com/Kitware/CMake/releases/download/v3.25.3/cmake-3.25.3.tar.gz /ltest2
ADD https://dlcdn.apache.org/logging/log4cxx/1.3.1/apache-log4cxx-1.3.1.tar.gz /ltest2
RUN dnf install -y epel-release
RUN dnf install -y --enablerepo=devel gcc-c++ cmake gtest-devel redis-devel hiredis-devel openssl openssl-devel apr apr-devel apr-util apr-util-devel zip  \
  postgresql-devel fmt fmt-devel which yum-utils java

#now install liquibase

RUN echo "[main]" >> /etc/yum.conf && echo "timeout=60" >> /etc/yum.conf
RUN echo "retries=20" >> /etc/yum.conf
RUN rpm --import https://repo.liquibase.com/liquibase.asc
RUN yum-config-manager --add-repo https://repo.liquibase.com/repo-liquibase-com.repo
RUN yum install -y liquibase

