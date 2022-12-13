#!/usr/bin/with-contenv bashio

CONFIG_PATH=/data/options.json
declare OVPNFILE
declare OPENVPN_CONFIG

if ! bashio::config.has_value 'ovpnfile' ; then
    bashio::exit.nok "no ovpnfile specified!"
fi

OVPNFILE=$(bashio::config 'ovpnfile')
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
    bashio::log.error "File ${OPENVPN_CONFIG} not found"
    bashio::log.error `cat $CONFIG_PATH`
    bashio::log.error `echo $OVPNFILE`
    bashio::log.error "Please specify the correct config file path in the settings page"
    exit 1
fi

init_tun_interface

bashio::log.info "Setup the VPN connection with the following OpenVPN configuration."

# try to connect to the server using the used defined configuration
openvpn --config ${OPENVPN_CONFIG}
bashio::log.error "We should not get here."

