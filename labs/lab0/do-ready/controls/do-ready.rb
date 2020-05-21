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

  describe command("tmsh show sys ip-address") do
    its("stdout") { should include "8.8.8.8"}
    its("stdout") { should include "8.8.4.4"}
  end
end


