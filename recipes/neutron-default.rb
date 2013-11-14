link '/etc/quantum' do
  to '/etc/neutron'
end

include_recipe 'openstack-network::common'

%w{
  remote_directory[/etc/quantum/rootwrap.d]
  template[/etc/quantum/rootwrap.conf]
}.each do |noop|
  rewind noop do
    action :nothing
  end
  # unwind noop # remote resource completely
end

rewind 'template[/etc/quantum/quantum.conf]' do
  source 'neutron.conf.erb'
  cookbook 'openstack-network-wrapper'
  path '/etc/neutron/neutron.conf'
end

rewind 'template[/etc/quantum/api-paste.ini]' do
  cookbook 'openstack-network-wrapper'
  path '/etc/neutron/api-paste.ini'
end

rewind 'template[/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini]' do
  source 'ovs_neutron_plugin.ini.erb'
  cookbook 'openstack-network-wrapper'
  path '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini'
end
