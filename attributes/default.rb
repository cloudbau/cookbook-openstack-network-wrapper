normal[:openstack][:release] = 'havana'
normal[:openstack][:apt][:components] = [ 'precise-updates/havana', 'main' ]

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

# We want to be able to update quota.
normal[:openstack][:network][:quota][:driver] = 'neutron.db.quota_db.DbQuotaDriver'

# By default we want overlapping ips.
normal[:openstack][:network][:allow_overlapping_ips] = "True"

# ovs_neutron_plugin.ini
normal[:openstack][:network][:openvswitch][:fw_driver] = 'neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver'

# nova.conf
normal[:openstack][:compute][:network][:service_type] = 'quantum'
normal[:openstack][:compute][:network][:quantum][:network_api_class] = 'nova.network.neutronv2.api.API'


normal[:openstack][:dashboard][:platform][:horizon_packages] = %w{ lessc python-lesscpy openstack-dashboard }
