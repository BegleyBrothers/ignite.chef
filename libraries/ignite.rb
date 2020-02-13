# We use a custom scheme (ignt) to identify the binary files to be installed.
module URI
  class Ignt < Generic
    DEFAULT_PORT = 873
  end
  @@schemes['IGNT'] = Ignt
end

# stub for service property :network in libraries/ignite_network.rb
module ::Ignite
  class Network
  end
  class Vm
  end
end
