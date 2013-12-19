include_recipe 'openstack-network-wrapper::default'
include_recipe 'openstack-network::dhcp_agent'

rewind 'template[/etc/quantum/dhcp_agent.ini]' do
  path '/etc/neutron/dhcp_agent.ini'
end
