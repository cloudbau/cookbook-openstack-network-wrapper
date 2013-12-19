
driver_name = node["openstack"]["network"]["interface_driver"].split('.').last.downcase
driver_map = node["openstack"]["network"]["interface_driver_map"]
main_plugin = driver_map[driver_name]

if main_plugin == "openvswitch"
  include_recipe "openstack-network-wrapper::openvswitch"
elsif main_plugin == "linuxbridge"
  include_recipe "openstack-network::linuxbridge"
else
  raise NotImplementedError.new("Only support: #{driver_map.values.join(", ")}")
end
