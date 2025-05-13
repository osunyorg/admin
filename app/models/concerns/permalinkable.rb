module Permalinkable
  extend ActiveSupport::Concern

  include Sluggable
  include Staticable

  included do
    has_many  :permalinks,
              class_name: "Communication::Website::Permalink",
              as: :about,
              dependent: :destroy
  end

  def previous_permalinks_in_website(website)
    permalinks.for_website(website)
              .not_current
              .not_root
  end

  # Persisted in db or nil
  def current_permalink_in_website(website)
    permalinks.for_website(website).current.first
  end

  def current_permalink_url_in_website(website)
    return if website.url.blank?
    path = current_permalink_in_website(website)&.path
    return if path.blank?
    "#{Static.remove_trailing_slash(website.url)}#{Static.clean_path(path)}"
  end

  # Not persisted yet
  def new_permalink_in_website(website)
    Communication::Website::Permalink.for_object(self, website)
  end

  # Called from git_file.sync
  def manage_permalink_in_website(website)
    new_permalink_in_website(website).save_if_needed
  end

  def add_redirection(path)
    clean_path = Communication::Website::Permalink.clean_path(path)
    Communication::Website::Permalink.create(
      website: website,
      about: self,
      is_current: false,
      path: clean_path
    )
  end

  def remove_redirection(permalink)
    permalink.destroy
  end

end
