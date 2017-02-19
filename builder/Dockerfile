FROM    alpine:3.5

ADD     repositories /etc/apk/repositories
RUN     apk --update add alpine-sdk && \
        mkdir -p /var/cache/distfiles && \
        adduser -D packager && \
        addgroup packager abuild && \
        chgrp abuild /var/cache/distfiles && \
        chmod g+w /var/cache/distfiles && \
        echo "packager    ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

ADD     setup.sh /home/packager/bin/setup.sh
# TODO: customize /etc/abuild.conf

WORKDIR /work
USER    packager
