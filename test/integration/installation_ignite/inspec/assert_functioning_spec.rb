describe command('/usr/bin/ignite version') do
  its(:exit_status) { should eq 0 }
end
describe command('/usr/bin/ignited version') do
  its(:exit_status) { should_not eq 0 }
end
