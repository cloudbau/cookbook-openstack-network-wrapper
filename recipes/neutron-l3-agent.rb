include_recipe 'openstack-network-wrapper::neutron-default'
include_recipe 'openstack-network::l3_agent'

# rewind 'template[/etc/quantum/l3_agent.ini]' do
#   path '/etc/neutron/l3_agent.ini'
# end
