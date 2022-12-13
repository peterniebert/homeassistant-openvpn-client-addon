ARG BUILD_FROM
FROM $BUILD_FROM

ENV LANG C.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install requirements for add-on
RUN apk --no-cache --no-progress upgrade && \
    apk --no-cache --no-progress add jq openvpn \
    rm -rf /tmp/*

# Copy data for add-on
COPY run.sh /

RUN chmod 555 /run.sh

CMD [ "/run.sh" ]
