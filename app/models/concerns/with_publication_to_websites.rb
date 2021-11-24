module WithPublicationToWebsites
  extend ActiveSupport::Concern

  included do
    after_save_commit :publish_to_every_website
    after_destroy :remove_from_every_website
  end

  protected

  def publish_to_every_website
    websites.each { |website| website.publish_object(self) }
  end

  def remove_from_every_website
    websites.each { |website| website.remove_object(self) }
  end

  # You can define a `github_path` method to re-define where to save the object markdown.
  # Check Communication::Website#publish_object for the default value.

end
