 yum_repository 'elastic' do
  description 'Elastic repository for 5.x packages'
  baseurl node['elastic']['repo']['base_uri']
  enabled true
  gpgcheck true
  gpgkey node['elastic']['repo']['gpg_key']
  action :add
  only_if { %w(centos redhat amazon scientific oracle).include?(node['platform']) }
 end
 package 'apt-transport-https' do
   only_if { node['platform_family'] == 'debian' }
 end
apt_repository 'elastic' do
  uri node['elastic']['repo']['base_uri']
  keyserver node['elastic']['repo']['gpg_key']
  distribution 'debian'
  components ['stable', 'main']
  only_if { %w(ubuntu).include?(node['platform']) }
end