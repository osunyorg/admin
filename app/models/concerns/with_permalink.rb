module WithPermalink
  extend ActiveSupport::Concern

  included do
    has_many  :permalinks,
              class_name: "Communication::Website::Permalink",
              as: :about,
              dependent: :destroy
  end

  def previous_permalinks_in_website(website)
    permalinks.for_website(website).not_current
  end

  # Persisted in db or nil
  def current_permalink_in_website(website)
    permalinks.for_website(website).current.first
  end

  # Not persisted yet
  def new_permalink_in_website(website)
    Communication::Website::Permalink.for_object(self, website)
  end

  # Called from git_file.sync
  def manage_permalink_in_website(website)
    new_permalink_in_website(website).save_if_needed
  end

end
