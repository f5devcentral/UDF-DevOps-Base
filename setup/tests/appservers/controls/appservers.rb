title "App Server Ready"

control "Demo App Ready" do
  impact 1.0
  title "NGINX Demo App"
  describe http("http://10.1.10.5") do
    its('body') { should match /Welcome to nginx/}
  end
  describe http("http://10.1.10.10") do
    its('body') { should match /Welcome to nginx/}
  end
end

control "NGINX Hello Ready" do
  impact 1.0
  title "NGINX Hello Ready"
  describe http("http://10.1.10.5:8080") do
    its('body') { should match /Hello World/}
  end
  describe http("http://10.1.10.10:8080") do
    its('body') { should match /Hello World/}
  end
end

control "JuiceShop Ready" do
  impact 1.0
  title "JuiceShop Ready"
  describe http("http://10.1.10.5:3000") do
    its('body') { should match /OWASP Juice Shop/}
  end
  describe http("http://10.1.10.10:3000") do
    its('body') { should match /OWASP Juice Shop/}
  end
end