ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install requirements for add-on
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add jq openvpn \
    rm -rf /tmp/*

# Copy data for add-on
RUN mkdir -p /etc/init.d/openvpn/
COPY run.sh /etc/init.d/openvpn

RUN chmod a+x /etc/init.d/openvpn/run.sh

# CMD [ "/run.sh" ]
