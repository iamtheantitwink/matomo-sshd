FROM matomo:fpm AS base

SHELL ["/bin/bash", "-o", "pipefail", "-o", "errexit", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

USER root

# Start and enable SSH
RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends dialog openssh-server nano nginx-common nginx && \
    dpkg --configure -a && \
    apt-get clean && \
    apt-get autoremove -y && \
    echo "root:Docker!" | chpasswd && \
    mkdir -p /.ssh /root

COPY --chown=root:root ./.ssh /.ssh
RUN chmod +x /.ssh/*
COPY ./entrypoint /entrypoint
COPY ./matomo.conf /etc/nginx/sites-available/default

RUN chmod +x /entrypoint 
RUN mkdir -p /run/sshd
RUN mkdir -p /root && echo '/.ssh/sshd-entrypoint' > /root/.bashrc
COPY sshd_config /etc/ssh/

EXPOSE 80 2222

ENTRYPOINT [ "/entrypoint" ]
CMD [ "php-fpm" ]