# copyright: 2020, F5 Networks

title "Declarative Onboarding Ready"

# Check Provisioning
control "Provisioning" do
  impact 1.0
  title "Test that correct BIG-IP modules are provisioned"

  describe command("tmsh list sys provision level | grep nominal -B2") do
    its("stdout") { should include "ltm"}
    its("stdout") { should include "gtm"}
  end
end

# Check DNS
control "DNS" do
  impact 1.0
  title "Test that the correct DNS name servers were set"

  describe command("tmsh list sys dns name-servers") do
    its("stdout") { should include "8.8.8.8"}
    its("stdout") { should include "8.8.4.4"}
  end
end

# Check VLANs
control "Internal VLAN Interface" do
  impact 1.0
  title "Test that the correct interface is set for the internal VLAN"

  describe command("tmsh list net vlan internal interfaces") do
    its("stdout") { should include "1.1"}
  end
end


control "External VLAN Interface" do
  impact 1.0
  title "Test that the correct interface is set for the external VLAN"

  describe command("tmsh list net vlan external interfaces") do
    its("stdout") { should include "1.2"}
  end
end

# Check Self-IP subnets
control "Internal Self IP" do
  impact 1.0
  title "Test that the correct subnet is assigned to the self-ip"

  describe command("tmsh list net self internal-self address") do
    its("stdout") { should include input("internal_sip")}
  end
end


control "External Self IP" do
  impact 1.0
  title "Test that the correct IP is assigned to the self-ip"

  describe command("tmsh list net self external-self address") do
    its("stdout") { should include input("external_sip")}
  end
end

# Admin Bash Shell
control "Bash Shell" do
  impact 1.0
  title "Test that the correct shell is set for the admin user"

  describe command("tmsh list auth user admin shell") do
    its("stdout") { should include "bash"}
  end
end


# GUI Banner
control "GUI Banner" do
  impact 1.0
  title "Test that the GUI Advisory Banner is set"

  describe command("tmsh list sys db ui.advisory.enabled") do
    its("stdout") { should include "true"}
  end
end