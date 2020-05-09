# copyright: 2020, F5 Networks

title "Test NGINX Demo Application"

control "Demo App Ready" do
  impact 1.0
  title "NGINX Demo App"
  describe http("http://10.1.20.20") do
    its('body') { should match /Hello World/}
  end
end
