include_recipe 'openstack-network::common'


platform_options = node["openstack"]["network"]["platform"]
platform_options["quantum_packages"].each do |pkg|
  cloudbau_rewind "package[#{pkg}]" do
    options platform_options["package_overrides"]
    action :upgrade
  end
end


# This is hard to keep up to date and it's not needed because
# our debian packages have the correct policy file already.
rewind "template[/etc/quantum/policy.json]" do
  action :nothing
end
