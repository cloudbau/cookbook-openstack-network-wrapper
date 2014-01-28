normal[:openstack][:network][:platform][:quantum_server_service] = 'neutron-server'
normal[:openstack][:network][:platform][:quantum_openvswitch_agent_service] = 'neutron-plugin-openvswitch-agent'
normal[:openstack][:network][:platform][:quantum_l3_agent_service] = 'neutron-l3-agent'
normal[:openstack][:network][:platform][:quantum_l3_packages] = [ 'neutron-l3-agent' ]
normal[:openstack][:network][:platform][:quantum_metadata_agent_service] = 'neutron-metadata-agent'
normal[:openstack][:network][:platform][:quantum_metadata_agent_packages] = [ 'neutron-metadata-agent' ]
normal[:openstack][:network][:platform][:quantum_dhcp_agent_service] = 'neutron-dhcp-agent'
normal[:openstack][:network][:platform][:quantum_dhcp_agent_packages] = [ 'neutron-dhcp-agent' ]
normal[:openstack][:network][:platform][:user] = 'neutron'
normal[:openstack][:network][:platform][:group] = 'neutron'

# neutron.conf
normal[:openstack][:network][:core_plugin] = 'neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2'
normal[:openstack][:network][:quota][:driver] = 'neutron.quota.ConfDriver'
normal[:openstack][:network][:interface_driver] = 'neutron.agent.linux.interface.OVSInterfaceDriver'
normal[:openstack][:network][:dhcp][:scheduler] = 'neutron.scheduler.dhcp_agent_scheduler.ChanceScheduler'
normal[:openstack][:network][:l3][:scheduler] = 'neutron.scheduler.l3_agent_scheduler.ChanceScheduler'
normal[:openstack][:network][:service_plugins] = %w{}

default[:openstack][:network][:plugin_map] = {
  'neutron.plugins.openvswitch.ovs_neutron_plugin.OVSNeutronPluginV2' => 'openvswitch',
  'neutron.plugins.linuxbridge.lb_neutron_plugin.LinuxBridgePluginV2' => 'linuxbridge',
  'neutron.plugins.ml2.plugin.Ml2Plugin' => 'ml2'
}


default[:openstack][:network][:plugin_conffile_path] = {
  'openvswitch' => %w{/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini},
  'linuxbridge' => %w{/etc/neutron/plugins/linuxbridge/linuxbridge_conf.ini},
  'ml2' => %w{
    /etc/neutron/plugins/ml2/ml2_conf.ini
    /etc/neutron/plugins/ml2/ml2_conf_extreme.ini
  }  
}

# We want to be able to update quota.
normal[:openstack][:network][:quota][:driver] = 'neutron.db.quota_db.DbQuotaDriver'

# By default we want overlapping ips.
normal[:openstack][:network][:allow_overlapping_ips] = "True"

# ovs_neutron_plugin.ini
normal[:openstack][:network][:openvswitch][:fw_driver] = 'neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver'

# linuxbridge_neutron_plugin.ini

normal[:openstack][:network][:linuxbridge][:fw_driver] = 'neutron.agent.linux.iptables_firewall.IptablesFirewallDriver'

# ML2
default['openstack']['network']['ml2']['type_drivers'] = %w{local flat vlan gre vxlan}
default['openstack']['network']['ml2']['tenant_network_types'] = %w{local}
default['openstack']['network']['ml2']['mechanism_drivers'] = %w{}
default['openstack']['network']['ml2']['flat']['flat_networks'] = %w{}

default['openstack']['network']['ml2']['vlan']['network_vlan_ranges'] = %w{}
default['openstack']['network']['ml2']['gre']['tunnel_id_ranges'] = %w{}
default['openstack']['network']['ml2']['vxlan']['vni_ranges'] = %w{}
default['openstack']['network']['ml2']['vxlan']['vxlan_group'] = ''
default["openstack"]["network"]["ml2"]["fw_driver"] = 'neutron.agent.linux.iptables_firewall.IptablesFirewallDriver'

# ML2 Extreme
default['openstack']['network']['ml2']['extreme']['host_to_port'] = %w{}
default['openstack']['network']['ml2']['extreme']['endpoints'] = %w{}
