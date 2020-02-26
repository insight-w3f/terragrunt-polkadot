[validators-0]
${validators_ip}

[validators-0:vars]
ansible_user=root
vpnpeer_address=10.0.0.1
vpnpeer_cidr_suffix=24
telemetryUrl=wss://mi.private.telemetry.backend/
loggingFilter='sync=trace,afg=trace,babe=debug'

[validator:children]
validator-0

[public-0]
${aws_ip}

[public-0:vars]
ansible_user=ubuntu
vpnpeer_address=10.0.0.2
vpnpeer_cidr_suffix=24
telemetryUrl=wss://mi.private.telemetry.backend/
loggingFilter='sync=trace,afg=trace,babe=debug'

[public:children]
public-0

[all:vars]
project=w3f
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o ConnectTimeout=15'
polkadot_binary_url='https://github.com/w3f/polkadot/releases/download/v0.6.11/polkadot'
polkadot_binary_checksum='sha256:ce6d4fd45f2c3ff91117423ed04c952ddde3b20f393e3ea05a2081f04b8a926b'
polkadot_network_id=ksmcc2
node_exporter_enabled='true'
node_exporter_user='node_exporter_user'
node_exporter_password='node_exporter_password'
node_exporter_binary_url='https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz'
node_exporter_binary_checksum='sha256:b2503fd932f85f4e5baf161268854bf5d22001869b84f00fd2d1f57b51b72424'
polkadot_restart_enabled='true'
polkadot_restart_minute='50'
polkadot_restart_hour='10'
polkadot_restart_day='1'
polkadot_restart_month='*'
polkadot_restart_weekday='*'
