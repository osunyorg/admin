module Communication::Website::WithPublishableObjects
  extend ActiveSupport::Concern

  included do

    def publish_about_object
      # TODO: Handle Research::Journal then use the commented version.
      # publish_object(about) unless about.nil?
      publish_object(about) if about.is_a?(Education::School)
    end

    def publish_object(object)
      # "object" can be an Education::Program, ...
      return unless github.valid?
      object_model_name = object.class.name.demodulize
      if object.respond_to?(:github_path)
        github_path = object.github_path
      else
        root_folder = "_#{object_model_name.pluralize.underscore}"
        github_path = "#{root_folder}/#{object.id}.md"
      end
      github_commit_message = "[#{object_model_name}] Save #{object.to_s}"
      github.publish(path: github_path, commit: github_commit_message, data: object.to_jekyll)
    end
    handle_asynchronously :publish_object, queue: 'default'

    def publish_blob(blob)
      return unless github.valid?
      blob.analyze unless blob.analyzed?
      github_path = "_data/media/#{blob.id[0..1]}/#{blob.id}.yml"
      github_commit_message = "[Medium] Save ##{blob.id}"
      data = ApplicationController.render(
        template: 'active_storage/blobs/jekyll',
        layout: false,
        assigns: { blob: blob }
      )
      github.publish(path: github_path, commit: github_commit_message, data: data)
    end
    handle_asynchronously :publish_blob, queue: 'default'

  end
end
