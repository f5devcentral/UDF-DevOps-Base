title "Client Server Ready"

control "Lab Redirect Ready" do
  impact 1.0
  title "Lab Redirect Ready"
  describe http("http://10.1.1.4") do
    its('body') { should match /302 Found/}
  end
end

control "VS Code Ready" do
  impact 1.0
  title "VS Code Ready"
  describe http("http://10.1.1.4:8080") do
    its('body') { should match /Microsoft Corporation/}
  end
end

control "Firefox Ready" do
  impact 1.0
  title "Firefox Ready"
  describe docker_container('firefox') do
    it { should exist }
    it { should be_running }
    its('repo') { should eq 'jlesage/firefox' }
    its('ports') { should eq "0.0.0.0:5800->5800/tcp, 5900/tcp" }
  end
  describe http("http://10.1.1.4:5800") do
    its('body') { should match /Firefox/}
  end
end

control "Terraform Ready" do
  impact 1.0
  title "Terraform Ready"
  describe command('terraform -version') do
    its('stdout') { should match /v0.12.29/ }
  end
end

control "F5 CLI Ready" do
  impact 1.0
  title "F5 CLI Ready"
  describe docker_container('f5-cli') do
    it { should exist }
    it { should be_running }
    its('repo') { should eq 'f5devcentral/f5-cli' }
    its('command') { should eq '/bin/bash' }
  end
end

control "Jinja2 Ready" do
  impact 1.0
  title "Jinja3 Ready"
  describe command('which jinja2') do
    its('stdout') { should match "/usr/local/bin/jinja2" }
  end
end

control "FAST Ready" do
  impact 1.0
  title "FAST Ready"
  describe command('which fast') do
    its('stdout') { should match "/usr/local/bin/fast" }
  end
end