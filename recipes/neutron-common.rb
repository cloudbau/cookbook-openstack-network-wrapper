include_recipe 'openstack-network::common'


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
