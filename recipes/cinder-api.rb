include_recipe 'openstack-block-storage::api'


# This is hard to keep up to date and it's not needed because
# our debian packages have the correct policy file already.
rewind "template[/etc/cinder/policy.json]" do
  action :nothing
end
