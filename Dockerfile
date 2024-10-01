FROM matomo:latest AS base

USER root

COPY ./start-with-sshd /start-with-sshd

# Start and enable SSH
RUN apt-get update \
    && apt-get install -y --no-install-recommends dialog \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "root:Docker!" | chpasswd  \
    && chmod +x /start-with-sshd \
    && mkdir -p /run/sshd
COPY sshd_config /etc/ssh/

EXPOSE 80 2222

ENTRYPOINT [ "/start-with-sshd" ]