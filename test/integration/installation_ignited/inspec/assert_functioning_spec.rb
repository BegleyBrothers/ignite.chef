describe command('/usr/bin/ignited version') do
  its(:exit_status) { should eq 0 }
end

describe command('/usr/bin/ignite version') do
  its(:exit_status) { should_not eq 0 }
end

describe docker.version do
  its('Server.Version') { should cmp >= '19.0'}
  its('Client.Version') { should cmp >= '19.0'}
end

describe docker.info do
  its('ContainersRunning') { should cmp < 1 }
end
