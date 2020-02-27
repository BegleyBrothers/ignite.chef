describe command('/usr/bin/ignite version') do
  its(:exit_status) { should eq 0 }
end
