#  service named 'default'
describe command('service ignited status') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/Running/) }
end
