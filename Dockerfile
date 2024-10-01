FROM matomo:latest AS base

USER root

COPY ./entrypoint /entrypoint

# Start and enable SSH
RUN apt-get update \
    && apt-get install -y --no-install-recommends dialog \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "root:Docker!" | chpasswd  \
    && chmod +x /entrypoint \
    && mkdir -p /run/sshd
COPY sshd_config /etc/ssh/

EXPOSE 80 2222

ENTRYPOINT [ "/entrypoint" ]
CMD [ "php-fpm" ]
