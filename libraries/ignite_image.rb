
module IgniteCookbook
  class IgniteImage < IgniteBase
    resource_name :ignite_image

    # Modify the default of read_timeout from 60 to 120
    property :read_timeout, default: 120, desired_state: false

    # https://docs.docker.com/engine/api/v1.35/#tag/Image
    property :destination, String
    property :force, [true, false], default: false, desired_state: false
    property :host, [String, nil], default: lazy { ENV['IGNITE_HOST'] }, desired_state: false
    property :nocache, [true, false], default: false
    property :noprune, [true, false], default: false
    property :repo, String, name_property: true
    property :rm, [true, false], default: true
    property :source, String
    property :tag, String, default: 'latest'

    alias_method :image, :repo
    alias_method :image_name, :repo
    alias_method :no_cache, :nocache
    alias_method :no_prune, :noprune

    #########
    # Actions
    #########

    default_action :pull

    action :build do
      converge_by "Build image #{image_identifier}" do
        build_image
      end
    end

    action :build_if_missing do
      return if Ignite::Image.exist?(image_identifier, {}, connection)
      action_build
    end

    action :import do
      return if Ignite::Image.exist?(image_identifier, {}, connection)
      converge_by "Import image #{image_identifier}" do
        import_image
      end
    end

    action :pull do
      # We already did the work, but we need to report what we did!
      converge_by "Pull image #{image_identifier}" do
      end if pull_image
    end

    action :pull_if_missing do
      return if Ignite::Image.exist?(image_identifier, {}, connection)
      action_pull
    end

    action :push do
      converge_by "Push image #{image_identifier}" do
        push_image
      end
    end

    action :remove do
      return unless Ignite::Image.exist?(image_identifier, {}, connection)
      converge_by "Remove image #{image_identifier}" do
        remove_image
      end
    end

    action :save do
      converge_by "Save image #{image_identifier}" do
        save_image
      end
    end

    action :load do
      converge_by "load image #{image_identifier}" do
        load_image
      end
    end

    declare_action_class.class_eval do
      ################
      # Helper methods
      ################

      def build_from_directory
        i = Ignite::Image.build_from_dir(
          new_resource.source,
          {
            'nocache' => new_resource.nocache,
            'rm'      => new_resource.rm,
          },
          connection
        )
        i.tag('repo' => new_resource.repo, 'tag' => new_resource.tag, 'force' => new_resource.force)
      end

      def build_from_ignite_manifest
        i = Ignite::Image.build(
          IO.read(new_resource.source),
          {
            'nocache' => new_resource.nocache,
            'rm'      => new_resource.rm,
          },
          connection
        )
        i.tag('repo' => new_resource.repo, 'tag' => new_resource.tag, 'force' => new_resource.force)
      end

      def build_from_tar
        i = Ignite::Image.build_from_tar(
          ::File.open(new_resource.source, 'r'),
          {
            'nocache' => new_resource.nocache,
            'rm'      => new_resource.rm,
          },
          connection
        )
        i.tag('repo' => new_resource.repo, 'tag' => new_resource.tag, 'force' => new_resource.force)
      end

      def build_image
        if ::File.directory?(new_resource.source)
          build_from_directory
        elsif ::File.extname(new_resource.source) == '.tar'
          build_from_tar
        else
          build_from_ignite_manifest
        end
      end

      def image_identifier
        "#{new_resource.repo}:#{new_resource.tag}"
      end

      def import_image
        with_retries do
          i = Ignite::Image.import(new_resource.source, {}, connection)
          i.tag('repo' => new_resource.repo, 'tag' => new_resource.tag, 'force' => new_resource.force)
        end
      end

      def pull_image
        with_retries do
          creds = credentails
          original_image = Ignite::Image.get(image_identifier, {}, connection) if Ignite::Image.exist?(image_identifier, {}, connection)
          new_image = Ignite::Image.create({ 'fromImage' => image_identifier }, creds, connection)

          !(original_image && original_image.id.start_with?(new_image.id))
        end
      end

      def push_image
        with_retries do
          creds = credentails
          i = Ignite::Image.get(image_identifier, {}, connection)
          i.push(creds, repo_tag: image_identifier)
        end
      end

      def remove_image
        with_retries do
          i = Ignite::Image.get(image_identifier, {}, connection)
          i.remove(force: new_resource.force, noprune: new_resource.noprune)
        end
      end

      def save_image
        with_retries do
          Ignite::Image.save(new_resource.repo, new_resource.destination, connection)
        end
      end

      def load_image
        with_retries do
          Ignite::Image.load(new_resource.source, {}, connection)
        end
      end

      def credentails
        registry_host = parse_registry_host(new_resource.repo)
        node.run_state['ignite_auth'] && node.run_state['ignite_auth'][registry_host] || (node.run_state['ignite_auth'] ||= {})['index.ignite_.io']
      end
    end
  end
end
