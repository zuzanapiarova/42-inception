# FTP

FROM debian:bookworm

RUN apt-get update && \
    apt-get install -y vsftpd ftp && \
    rm -rf /var/lib/apt/lists/*

# vsftpd expects its config at /etc/vsftpd.conf
COPY ./tools/vsftpd.conf /etc/vsftpd.conf

# vsftpd needs the chroot directory to exist.
RUN mkdir -p /var/run/vsftpd/empty && chmod 755 /var/run/vsftpd/empty

COPY ./tools/01-ftp-init.sh /usr/local/bin/01-ftp-init.sh
RUN chmod +x /usr/local/bin/01-ftp-init.sh

EXPOSE 21 30000-30009

CMD ["01-ftp-init.sh"]