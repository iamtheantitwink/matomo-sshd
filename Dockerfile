FROM matomo:latest AS base

COPY start-sshd ./

USER root

# Start and enable SSH
RUN apt-get update \
    && apt-get install -y --no-install-recommends dialog \
    && apt-get install -y --no-install-recommends openssh-server \
    && echo "root:Docker!" | chpasswd  \
    && chmod +x start-sshd
COPY ./sshd_config /etc/ssh/

EXPOSE 80 2222

CMD [ "start-sshd" ]