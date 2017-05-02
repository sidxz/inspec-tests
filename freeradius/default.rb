# InSpec Test For inspec-test-freeradius::default
# maintainer 'Sid'
# maintainer_email 'sid@tamu.edu'


control "Firewall" do
  title "Firewall should be enabled and running. Port 1812 should be open."
  describe service('firewalld') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
  describe port 1812 do
    it { should be_listening }
  end
end

control "Radius Service" do
  title "Service radiusd should be enabled and running"
  describe service('radiusd') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end


control "Radius Policy -> Test User" do
  title "Test radius policy with a vailid user, should get welcome mesaage"
  describe command('radtest <%= @ldap['username'] %>  "<%= @ldap['password'] %>" localhost 0 testing123') do
    its('stdout') { should match 'Received Access-Accept Id ' }
  end
end

control "Radius Policy -> Invalid User" do
  title "Test radius policy witha a random user, should get reject"
  describe command('radtest randomUser password localhost 0 testing123') do
    its('stdout') { should match 'ACCESS DENIED BY POLICY' }
  end
end
