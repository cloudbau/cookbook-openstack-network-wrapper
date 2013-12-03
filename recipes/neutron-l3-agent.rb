include_recipe 'openstack-network::l3_agent'

driver_name = node["openstack"]["network"]["interface_driver"].split('.').last.downcase
main_plugin = node["openstack"]["network"]["interface_driver_map"][driver_name]

if not ["nicira", "plumgrid", "bigswitch", "linuxbridge"].include?(main_plugin)
  ext_bridge = node["openstack"]["network"]["l3"]["external_network_bridge"]
  ext_bridge_iface = node["openstack"]["network"]["l3"]["external_network_bridge_interface"]

  cmd = "ovs-vsctl add-br #{ext_bridge}"
  # XXX(Mouad): If no external connection is required no need to add port
  # to iface, something that didn't occur to stackforge guys !!
  if ext_bridge_iface.nil? or ext_bridge_iface.empty?
    cmd += " && ovs-vsctl add-port #{ext_bridge} #{ext_bridge_iface}"
  end

  rewind 'execute[create external network bridge]' do
    command cmd
    action :run
    not_if "ovs-vsctl show | grep 'Bridge #{ext_bridge}'"
    only_if "ip link show #{ext_bridge_iface}"
  end
end
