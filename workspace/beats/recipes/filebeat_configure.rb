directory node['filebeat']['conf']['home_directory'] do
  recursive true
end
template node['filebeat']['conf']['file'] do
  source 'filebeat.yml.erb'
  sensitive true
  notifies :restart, "service[#{node['filebeat']['service']['name']}]"
end