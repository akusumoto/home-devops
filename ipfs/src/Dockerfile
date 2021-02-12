FROM ipfs/go-ipfs

EXPOSE 8080/tcp 8081/tcp 4001/tcp 4001/udp 5001/tcp 4471/tcp 4471/udp

COPY start_ipfs /usr/local/bin/start_ipfs

RUN chmod 0755 /usr/local/bin/start_ipfs

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/start_ipfs"]
CMD ["daemon", "--migrate=true"]
