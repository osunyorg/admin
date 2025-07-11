class Communication::Website::Alert::Localization < ApplicationRecord
  include AsLocalization
  include HasGitFiles
  include Initials
  include Permalinkable # slug_unavailable method overwrite in this file
  include Sanitizable
  include WithPublication
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  alias :alert :about

  validates :title, presence: true

  before_validation :set_communication_website_id, on: :create

  def git_path(website)
    return unless website.id == communication_website_id && published && published_at
    git_path_content_prefix(website) + git_path_relative
  end

  # alerts/slug.html
  def git_path_relative
    "alerts/#{slug}.html"
  end

  def template_static
    "admin/communication/websites/alerts/static"
  end

  def cta_url_external?(website)
    return false if cta_url.blank?
    !cta_url_internal?(website)
  end

  def cta_url_internal?(website)
    return false if cta_url.blank?
    cta_url.start_with?('/') || cta_url.start_with?(website.url)
  end

  def to_s
    "#{title}"
  end

  protected

  def slug_unavailable?(slug)
    self.class.unscoped
              .left_joins(:about)
              .where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end
end
