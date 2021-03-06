include_recipe 'openstack-network::common'

platform_options = node["openstack"]["network"]["platform"]
platform_options["quantum_packages"].each do |pkg|
  cloudbau_rewind "package[#{pkg}]" do
    options platform_options["package_overrides"]
    action :upgrade
  end
end

# This is hard to keep up to date and it's not needed because
# our debian packages contain already an up to date version
# of this files.
%w{
  remote_directory[/etc/quantum/rootwrap.d]
  template[/etc/quantum/rootwrap.conf]
  template[/etc/quantum/policy.json]
}.each do |noop|
  rewind noop do
    action :nothing
  end
  # unwind noop # remote resource completely
end


db_user = node["openstack"]["network"]["db"]["username"]
db_pass = db_password "quantum"
sql_connection = db_uri("network", db_user, db_pass)
# XXX(Mouad): Get original template resource variables.
parent_variables = run_context.resource_collection.find('template[/etc/quantum/quantum.conf]').variables
rewind 'template[/etc/quantum/quantum.conf]' do
  source 'neutron.conf.erb'
  cookbook 'openstack-network-wrapper'
  path '/etc/neutron/neutron.conf'
  variables(
    :sql_connection => sql_connection,
  ).update(parent_variables)
end

rewind 'template[/etc/quantum/api-paste.ini]' do
  cookbook 'openstack-network-wrapper'
  path '/etc/neutron/api-paste.ini'
end

driver_name = node["openstack"]["network"]["interface_driver"].split('.').last.downcase
driver_map = node["openstack"]["network"]["interface_driver_map"]
main_plugin = driver_map[driver_name]

if main_plugin == "openvswitch"
  plugin_conffile_path = '/etc/neutron/plugins/openvswitch/ovs_neutron_plugin.ini'
  rewind 'template[/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini]' do
    cookbook 'openstack-network-wrapper'
    source 'ovs_neutron_plugin.ini.erb'
    path plugin_conffile_path
  end

  # OVS agent doesn't get started automatically
  rewind 'template[/etc/quantum/plugins/openvswitch/ovs_quantum_plugin.ini]' do
    notifies :restart, "service[quantum-plugin-openvswitch-agent]", :delayed
  end

elsif main_plugin == "linuxbridge"
  plugin_conffile_path = '/etc/neutron/plugins/linuxbridge/linuxbridge_conf.ini'
  rewind 'template[/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini]' do
    cookbook 'openstack-network-wrapper'
    source 'linuxbridge_conf.ini.erb'
    path plugin_conffile_path
  end

  # Linux bridge agent doesn't get started automatically
  rewind 'template[/etc/quantum/plugins/linuxbridge/linuxbridge_conf.ini]' do
    notifies :restart, "service[quantum-plugin-linuxbridge-agent]", :delayed
  end
else
  raise NotImplementedError.new("Only support: #{driver_map.values.join(", ")}")
end

# Rewrite init script to fix neutron-server configuration
template "/etc/init/neutron-server.conf" do
  source "neutron-server.conf.erb"
  mode 00644
  variables(
    :plugin_conffile_path => plugin_conffile_path
  )
end
