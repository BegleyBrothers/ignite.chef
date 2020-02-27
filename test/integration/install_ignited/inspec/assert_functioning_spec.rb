describe command('/usr/bin/ignited version') do
  its(:exit_status) { should eq 0 }
end
