include_recipe "openstack-network::openvswitch"


platform_options = node["openstack"]["network"]["platform"]
platform_options["quantum_openvswitch_packages"].each do |pkg|
  rewind "package[#{pkg}]" do
    action :install
    options platform_options["package_overrides"]
  end
end

# When installing openvswitch from custom made packages and
# if they don't have automatic service start enabled (which is
# what they should do) then we do this here.  
service "openvswitch-switch" do
  action :nothing
end

if !node['openstack']['network']['openvswitch']['use_source_version']
  platform_options["quantum_openvswitch_packages"].each do |pkg|
    rewind "package[#{pkg}]" do
      notifies :restart, "service[openvswitch-switch]", :immediately
    end
  end
end
