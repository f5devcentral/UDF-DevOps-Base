title "BIG-IP Ready"

include_controls 'big-ip-atc-ready' do
  skip_control 'bigip-telemetry-streaming'
  skip_control 'bigip-telemetry-streaming-version'
end
