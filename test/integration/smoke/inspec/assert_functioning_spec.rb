#  service named 'default'

unless os.windows?
  # This is an example test, replace with your own test.
  describe user('root'), :skip do
    it { should exist }
  end
end

describe command('ignite images') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/weaveworks\/ignite-ubuntu:latest/) }
  its(:stdout) { should match(/226\.5 MB/) }
  its(:stdout) { should_not match(/alpine/) }

end


describe command('ignite ps --all') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/weaveworks\/ignite-kernel:4.19.47/) }
  its(:stdout) { should match(/rpfrdqxmffadvn6t/) }
  its(:stdout) { should match(/1\.2 GB/) }
  its(:stdout) { should match(/456\.0 MB/) }
end

describe command('ignite images ls') do
  its(:exit_status) { should eq 0 }
  its('stdout') { should match(/weaveworks\/ignite-ubuntu:latest/) }
  its(:stdout) { should match(/226\.5 MB/) }
end
