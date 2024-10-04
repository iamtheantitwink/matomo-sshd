FROM matomo:fpm AS base

ENV DEBIAN_FRONTEND=noninteractive

USER root

# Start and enable SSH
RUN apt-get update
RUN apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends dialog
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openssh-server nano
RUN DEBIAN_FRONTEND=noninteractive echo "N" | apt-get install -y --no-install-recommends nginx-common
RUN dpkg --configure -a 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nginx 
RUN apt-get clean 
RUN apt-get autoremove -y 
RUN echo "root:Docker!" | chpasswd 
RUN mkdir -p /.ssh
RUN mkdir -p /root

COPY --chown=root:root ./.ssh /.ssh
RUN chmod +x /.ssh/*
COPY ./entrypoint /entrypoint
COPY ./matomo.conf /etc/nginx/sites-available/default
RUN "echo '/.ssh/sshd-entrypoint' > /root/.bashrc"

RUN chmod +x /entrypoint 
RUN mkdir -p /run/sshd

COPY sshd_config /etc/ssh/

EXPOSE 80 2222

ENTRYPOINT [ "/entrypoint" ]
CMD [ "php-fpm" ]
