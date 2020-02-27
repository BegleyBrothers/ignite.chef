#  service named 'ignite-ignited'

describe service('ignite-ignited') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe upstart_service('ignite-ignited') do
  it { should_not be_enabled }
  it { should be_installed }
  it { should be_running }
end

describe runit_service('ignite-ignited') do
  it { should be_enabled }
  it { should be_installed }
  it { should be_running }
end
