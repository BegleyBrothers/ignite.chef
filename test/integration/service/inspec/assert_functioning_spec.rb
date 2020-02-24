#  service named 'ignite'
describe command('service ignite status') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should_not match(/Running/) }
end
