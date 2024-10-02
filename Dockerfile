FROM ghcr.io/iamtheantitwink/sshd:latest AS sshd

FROM matomo:latest AS base

COPY --from=sshd /start-sshd /
COPY --from=sshd /etc/ssh /etc/ssh
COPY --from=sshd /usr/sbin/sshd /usr/sbin/sshd

EXPOSE 80 2222

CMD [ "/start-sshd" ]