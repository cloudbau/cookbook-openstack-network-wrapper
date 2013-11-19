include_recipe "openstack-compute::compute"
include_recipe "openstack-compute::nova-common"

# We don't want to install nova-compute-kvm because it's bring
# a lot of unwanted dependencies e.g. nova-common, nova-compute ...
rewind "package[nova-compute-kvm]" do
  action :nothing
end

rewind 'template[/etc/nova/rootwrap.d/api-metadata.filters]' do
  source 'rootwrap.d/api-metadata.filters.erb'
  cookbook_name 'openstack-network-wrapper'
end

rewind 'template[/etc/nova/rootwrap.d/compute.filters]' do
  source 'rootwrap.d/compute.filters.erb'
  cookbook_name 'openstack-network-wrapper'
end

rewind 'template[/etc/nova/rootwrap.d/network.filters]' do
  source 'rootwrap.d/network.filters.erb'
  cookbook_name 'openstack-network-wrapper'
end
