# copyright: 2020, F5 Networks

title "Test NGINX Demo Application"

control "NGINX Default App Ready" do
  impact 1.0
  title "NGINX Demo App"
  describe http("http://10.1.20.10") do
    its('body') { should match /nginx/}
  end
end

control "Demo App Ready on 8080" do
  impact 1.0
  title "NGINX Demo App"
  describe http("http://10.1.20.10:8080") do
    its('body') { should match /Hello World/}
  end
end
