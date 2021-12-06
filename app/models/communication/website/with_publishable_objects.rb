module Communication::Website::WithPublishableObjects
  extend ActiveSupport::Concern

  included do

    def publish_about_object
      # TODO: Handle Research::Journal then use the commented version.
      # about.force_publish! unless about.nil?
      about.force_publish! if about.is_a?(Education::School)
    end

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

    def remove_blob(blob)
      return unless github.valid?
      github_path = "_data/media/#{blob.id[0..1]}/#{blob.id}.yml"
      github_commit_message = "[Medium] Remove ##{blob.id}"
      github.remove(github_path, github_commit_message)
    end
  end
end
