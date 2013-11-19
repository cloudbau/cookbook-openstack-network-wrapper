include_recipe "openstack-dashboard::server"

platform_options = node["openstack"]["dashboard"]["platform"]
platform_options["memcache_python_packages"].each do |pkg|
 rewind "package[#{pkg}]" do
   # Virtualenv of horizon contain already python-memcache.
   action :nothing
 end
end

dash_path = node["openstack"]["dashboard"]["dash_path"]

rewind "execute[openstack-dashboard syncdb]" do
  cwd dash_path 
  environment ({'PYTHONPATH' => "#{dash_path}:$PYTHONPATH"})
  command "/opt/cloudbau/horizon-virtualenv/bin/python manage.py syncdb --noinput"
end

rewind "template[#{node["openstack"]["dashboard"]["apache"]["sites-path"]}]" do
  source 'dash-site.erb'
  cookbook 'openstack-network-wrapper'
end

rewind "template[#{node["openstack"]["dashboard"]["local_settings_path"]}]" do
  source 'local_settings.py.erb'
  cookbook 'openstack-network-wrapper'
end 

execute 'manage.py compress' do
  command '/opt/cloudbau/horizon-virtualenv/bin/python /opt/cloudbau/horizon-virtualenv/openstack_dashboard/manage.py compress'
  user 'www-data'
  group 'www-data'
end

rewind 'execute[openstack-dashboard syncdb]' do
  user 'www-data'
  group 'www-data'
end
