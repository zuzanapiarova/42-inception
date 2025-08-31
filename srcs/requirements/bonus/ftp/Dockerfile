# FTP

FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y \
    vsftpd

    # iproute2

# vsftpd expects its config at /etc/vsftpd.conf - replace
COPY ./tools/vsftpd.conf /etc/vsftpd.conf

# On Debian, vsftpd requires a secure chroot directory (secure_chroot_dir) to exist. by default, the config points to /var/run/vsftpd/empty. if that directory does not exist inside the container, vsftpd refuses to start sessions
RUN mkdir -p /var/run/vsftpd/empty && chmod 755 /var/run/vsftpd/empty

# startup script 
COPY ./tools/ftp-init.sh /usr/local/bin/ftp-init.sh
RUN chmod +x /usr/local/bin/ftp-init.sh

EXPOSE 21 30000-30009 

ENTRYPOINT ["/usr/local/bin/ftp-init.sh"]