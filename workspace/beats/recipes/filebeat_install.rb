remote_file "#{Chef::Config['file_cache_path']}/#{node['filebeat']['binary']['package']}" do
  source node['filebeat']['binary']['uri']
  notifies :install, "dpkg_package[#{node['filebeat']['binary']['package']}]", :immediately
  notifies :install, "yum_package[#{node['filebeat']['binary']['package']}]", :immediately
end
dpkg_package node['filebeat']['binary']['package'] do
  source "#{Chef::Config['file_cache_path']}/#{node['filebeat']['binary']['package']}"
  action :nothing
  only_if { node['platform_family'] == 'debian' }
end
yum_package node['filebeat']['binary']['package'] do
  source "#{Chef::Config['file_cache_path']}/#{node['filebeat']['binary']['package']}"
  action :nothing
  only_if { node['platform_family'] == 'rhel' }
end