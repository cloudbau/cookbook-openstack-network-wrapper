include_recipe "openstack-compute::api-ec2"


service "nova-objectstore" do
  service_name "nova-objectstore"
  supports :status => true, :restart => true
  subscribes :restart, resources("template[/etc/nova/nova.conf]")

  action :enable
end
