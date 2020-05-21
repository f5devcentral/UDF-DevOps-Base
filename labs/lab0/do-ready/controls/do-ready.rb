# copyright: 2020, F5 Networks

title "Declarative Onboarding Ready"

# Check DNS
control "DNS Configured" do
  impact 1.0
  title "DNS Set to 8.8.8.8 and 8.8.4.4"
  desc "Ensure that the correct DNS is set"

  describe command("tmsh show sys ip-address") do
    its("stdout") { should include "8.8.8.8"}
    its("stdout") { should include "8.8.4.4"}
  end
end


