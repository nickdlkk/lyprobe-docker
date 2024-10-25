FROM centos:7.9.2009

LABEL authors="Nick"
ENV TINI_VERSION="v0.19.0"
ENV LYPROBE_VERSION="1.0.1"

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# 配置阿里云镜像源
RUN echo "[base]" > /etc/yum.repos.d/CentOS-Base.repo \
    && echo "name=CentOS-\$releasever - Base" >> /etc/yum.repos.d/CentOS-Base.repo \
    && echo "baseurl=http://mirrors.aliyun.com/centos/7/os/x86_64/" >> /etc/yum.repos.d/CentOS-Base.repo \
    && echo "gpgcheck=0" >> /etc/yum.repos.d/CentOS-Base.repo

# 安装必要的工具和 MySQL 客户端库
RUN yum update -y --nogpgcheck \
    && yum install -y --nogpgcheck wget tar mysql libpcap-devel 

# 下载 ly_probe 包
ADD https://github.com/Abyssal-Fish-Technology/ly_probe/releases/download/v${LYPROBE_VERSION}/lyprobe-release-v${LYPROBE_VERSION}.tar.gz /lyprobe

# 解压缩包
RUN tar -zxvf lyprobe.tar.gz

# 进入解压后的目录并执行安装
WORKDIR lyprobe-release-v${LYPROBE_VERSION}
RUN cp ./lyprobe /usr/local/bin/ \
    && cp -d ./liblyprobe* /usr/local/lib/ \
    && cp -rd ./plugins /usr/local/lib/lyprobe/

# 使用 tini 持久化进程
ENTRYPOINT ["/tini", "--"]
CMD ["lyprobe"]
