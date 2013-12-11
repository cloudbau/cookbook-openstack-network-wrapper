include_recipe 'openstack-network::common'


# Custom rewind that take at the opposite of chef/rewind doesn't
# assume that there is no duplicate resource, instead it will
# "rewind" all resources with name `resource_id`.
def cloudbau_rewind(resource_id, &block)
  run_context.resource_collection.each {
    |r| r.instance_exec(&block) if block and r.to_s == resource_id
  }
end


platform_options = node["openstack"]["network"]["platform"]
platform_options["quantum_packages"].each do |pkg|
  cloudbau_rewind "package[#{pkg}]" do
    options platform_options["package_overrides"]
    action :upgrade
  end
end


platform_options = node["openstack"]["image"]["platform"]
platform_options["image_packages"].each do |pkg|
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
