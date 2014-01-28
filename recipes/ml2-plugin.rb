unless node['openstack']['network']['core_plugin'] == 'neutron.plugins.ml2.plugin.Ml2Plugin'
  return
end

template '/etc/neutron/plugins/ml2/ml2_conf.ini' do
  source 'ml2_conf.ini.erb'
  mode 00644
  user node['openstack']['network']['platform']['user']
  group node['openstack']['network']['platform']['password']

  notifies :restart, 'service[quantum-server]', :delayed
end

template '/etc/neutron/plugins/ml2/ml2_conf_extreme.ini' do
  source 'ml2_conf_extreme.ini.erb'
  mode 00644
  user node['openstack']['network']['platform']['user']
  group node['openstack']['network']['platform']['password']

  notifies :restart, 'service[quantum-server]', :delayed
end
