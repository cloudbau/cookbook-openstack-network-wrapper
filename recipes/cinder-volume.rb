driver = node["openstack"]["block-storage"]["volume"]["driver"]

if driver == "cinder.volume.drivers.lvm.LVMISCSIDriver"
  vol_grp = node["openstack"]["block-storage"]["volume"]["volume_group"]
  stat_dir = node["openstack"]["block-storage"]["volume"]["state_path"]

  local_file = File.join(stat_dir, vol_grp)
  size = ((`df -Pk #{stat_dir}`.split("\n")[1].split(" ")[3].to_i * 1024) * 0.90).to_i rescue 0

  bash "create local volume file" do
    code "truncate -s #{size} #{local_file}"
    not_if do
      File.exists?(local_file)
    end
  end

  bash "setup loop device for volume" do
    code "losetup -f --show #{local_file}"
    not_if "losetup -j #{local_file} | grep #{local_file}"
  end

  bash "create volume group" do
    code "vgcreate #{vol_grp} `losetup -j #{local_file} | cut -f1 -d:`"
    not_if "vgs #{vol_grp}"
    notifies :restart, "service[cinder-volume]", :delayed
  end

  template "/etc/tgt/conf.d/cinder.conf" do
    source "cinder.conf.erb"
  end

end
