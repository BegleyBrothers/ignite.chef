#########################
# :rm
#########################

ignite_image_rm 'hello-world' do
  dangling true
end

ignite_image_rm 'prune-old-images' do
  dangling true
  prune_until '1h30m'
  with_label 'com.example.vendor=ACME'
  without_label 'no_prune'
  action :prune
end
