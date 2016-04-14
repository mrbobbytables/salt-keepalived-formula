require 'serverspec'
require 'yaml'

set :backend, :exec

pillar_data = YAML.load_file('/tmp/kitchen/srv/pillar/keepalived.sls')
config = pillar_data['keepalived']['lookup']['config']
scripts = pillar_data['keepalived']['lookup']['scripts']
salt_provider = %x(salt-call --local --config-dir=/tmp/kitchen/etc/salt test.provider service)

case salt_provider[/local:\s+(?<provider>\S+)/, :provider] 
when 'systemd'
  provider = 'systemd'
else
  provider = 'other'
end

describe 'SLS: keepalived.install' do

  describe 'STATE: enable-non-local-bind' do
    describe command('sysctl -a') do
      its(:stdout) { should contain /^net.ipv4.ip_nonlocal_bind = 1$/ }
    end
  end

  describe 'STATE: install-keepalived-package' do
    describe package('keepalived') do
      it { should be_installed }
    end
  end
end

describe 'SLS: keepalived.config' do

  scripts.each do | script|
    describe "STATE: sync-keepalived-script-#{script['name']}" do
      describe file(script['name']) do
        it { should exist }
        it { should be_file }
        it { should be_owned_by script['user'] || 'root' }
        it { should be_grouped_into script['group'] || 'root' }
        it { should be_mode script['mode'] || 700 }
      end
    end
  end

  describe 'STATE: config-keepalived' do
    describe file('/etc/keepalived/keepalived.conf') do
      it { should exist }
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 644 }
    end
  end
end


describe 'SLS: keepalived.service' do
  if provider == 'systemd'
    describe 'STATE: keepalived-systemd-enable-service' do
      describe service('keepalived.service') do
        it { should be_enabled }
        it { should be_running }
      end
    end
  else
    describe 'STATE: keepalived-enable-service' do
      describe service('keepalived') do
        it { should be_enabled }
        it { should be_running }
      end
    end
  end
end


