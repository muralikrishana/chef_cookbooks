service node['filebeat']['service']['name'] do
  action [:stop , :disable]
end
package node['filebeat']['binary']['name']  do
  action :remove
end
directory node['filebeat']['conf']['base_directory'] do
  recursive true
  action :delete
end
file "#{Chef::Config['file_cache_path']}/#{node['filebeat']['binary']['package']}" do
  action :delete
end