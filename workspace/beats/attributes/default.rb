default['filebeat']['binary']['version']='5.1.2'
default['metricbeat']['binary']['version']='5.1.2'

case node['platform_family']
  when 'debian'
    default['filebeat']['binary']['package']="filebeat-#{node['filebeat']['binary']['version']}-amd64.deb"
    default['metricbeat']['binary']['package']="filebeat-#{node['filebeat']['binary']['version']}-amd64.deb"
  when 'rhel'
    default['filebeat']['binary']['package']="filebeat-#{node['filebeat']['binary']['version']}-x86_64.rpm"
    default['metricbeat']['binary']['package']="filebeat-#{node['filebeat']['binary']['version']}-x86_64.rpm"
end
default['filebeat']['binary']['uri']="https://artifacts.elastic.co/downloads/beats/filebeat/#{node['filebeat']['binary']['package']}"

default['metricbeat']['binary']['uri']="https://artifacts.elastic.co/downloads/beats/filebeat/#{node['filebeat']['binary']['package']}"

default['filebeat']['binary']['name']='filebeat'
default['filebeat']['conf']['base_directory']='/etc/filebeat'
default['filebeat']['conf']['file']="#{node['filebeat']['conf']['base_directory']}/filebeat.yml"
default['filebeat']['conf']['home_directory']="#{node['filebeat']['conf']['base_directory']}/conf.d"


default['filebeat']['service']['name']='filebeat'