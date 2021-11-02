#!/usr/bin/env bash
set -eo pipefail

CONFIG_PATH=/data/options.json

OVPNFILE="$(jq --raw-output '.ovpnfile' $CONFIG_PATH)"
OPENVPN_CONFIG=${OVPNFILE}

########################################################################################################################
# Initialize the tun interface for OpenVPN if not already available
# Arguments:
#   None
# Returns:
#   None
########################################################################################################################
function init_tun_interface() {
    # create the tunnel for the openvpn client

    mkdir -p /dev/net
    if [ ! -c /dev/net/tun ]; then
        mknod /dev/net/tun c 10 200
    fi
}

if [[ ! -f ${OPENVPN_CONFIG} ]]; then
    echo "File ${OPENVPN_CONFIG} not found"
    echo "Please specify the correct config file path in the settings page"
    exit 1
fi

init_tun_interface

echo "Setup the VPN connection with the following OpenVPN configuration."

# try to connect to the server using the used defined configuration
openvpn --config ${OPENVPN_CONFIG}
