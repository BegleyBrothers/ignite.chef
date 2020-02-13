#  service named 'default'
describe command('ignite images') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/busybox/) }
end

describe command('ignite ps --all') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/an_echo_server/) }
end

# service one
describe command('ignite images ls') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/^hello-world/) }
  its(:stdout) { should_not match(/^alpine/) }
end

describe command('ignite ps --all') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/hello-world/) }
  its(:stdout) { should_not match(/an_echo_server/) }
end
