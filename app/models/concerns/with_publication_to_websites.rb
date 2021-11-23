module WithPublicationToWebsites
  extend ActiveSupport::Concern

  included do
    after_save_commit :publish_to_every_websites
  end

  protected

  def publish_to_every_websites
    websites.each { |website| website.publish_object(self) }
  end

  # You can define a `github_path` method to re-define where to save the object markdown.
  # Check Communication::Website#publish_object for the default value.

end
