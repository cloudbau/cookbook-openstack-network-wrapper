include_recipe 'openstack-network::l3_agent'

begin
  ext_bridge = node["openstack"]["network"]["l3"]["external_network_bridge"]
  ext_bridge_iface = node["openstack"]["network"]["l3"]["external_network_bridge_interface"]
  cmd = "ovs-vsctl add-br #{ext_bridge}"
  # XXX(Mouad): If no external connection is required no need to add port
  # to iface, something that didn't occur to stackforge guys !!
  if ext_bridge_iface == ""
    cmd += " && ovs-vsctl add-port #{ext_bridge} #{ext_bridge_iface}"
  end
  rewind 'execute[create external network bridge]' do
    command cmd
    action :run
    not_if "ovs-vsctl show | grep 'Bridge #{ext_bridge}'"
    only_if "ip link show #{ext_bridge_iface}"
  end
rescue Chef::Exceptions::ResourceNotFound
  # No resource found mean that either we are in no openvwitch land, or that
  # resource was renamed, hopefully not the latest :)
end
