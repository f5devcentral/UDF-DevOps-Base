# copyright: 2020, F5 Networks

title "Declarative Onboarding Ready"

# Check DNS
control "Declarative Onboarding Ready" do
  impact 1.0
  title "Test that DO configured the BIG-IP"
  desc "Ensure that the correct BIG-IP settings were made"

  describe command("tmsh list sys provision level | grep nominal -B2") do
    its("stdout") { should include "ltm"}
    its("stdout") { should include "gtm"}
  end

  describe command("tmsh show sys ip-address") do
    its("stdout") { should include "8.8.8.8"}
    its("stdout") { should include "8.8.4.4"}
  end
end


