# == Schema Information
#
# Table name: communication_website_localizations
#
#  id               :uuid             not null, primary key
#  name             :string
#  published        :boolean          default(FALSE)
#  published_at     :datetime
#  social_email     :string
#  social_facebook  :string
#  social_github    :string
#  social_instagram :string
#  social_linkedin  :string
#  social_mastodon  :string
#  social_peertube  :string
#  social_tiktok    :string
#  social_vimeo     :string
#  social_x         :string
#  social_youtube   :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  about_id         :uuid             not null, indexed
#  language_id      :uuid             not null, indexed
#  university_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_localizations_on_about_id       (about_id)
#  index_communication_website_localizations_on_language_id    (language_id)
#  index_communication_website_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_2b920b0a3a  (language_id => languages.id)
#  fk_rails_431797c26c  (about_id => communication_websites.id)
#  fk_rails_fc42676b8b  (university_id => universities.id)
#
class Communication::Website::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include Initials
  include WithAccessibility
  include WithOpenApi
  include WithPublication
  include WithUniversity

  alias :website :about

  validates :name, presence: true
  validate :prevent_unpublishing_default_language

  after_create_commit :create_existing_menus_in_language
  after_save :mark_website_obsolete_git_files, if: :should_clean_website_on_git?

  # Localization is not directly exportable to git
  # Whereas the languages config in the dependencies is exportable to git
  def exportable_to_git?
    false
  end

  def dependencies
    # 1 single file for all the languages
    [website.config_default_languages] +
    contents_dependencies
  end

  def to_s
    name
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def create_existing_menus_in_language
    menus = website.menus.for_language_id(website.default_language_id)
    menus.each do |menu|
      new_menu = menu.dup
      new_menu.language_id = language_id
      new_menu.save
    end
  end

  def should_clean_website_on_git?
    # Clean website if l10n was unpublished
    saved_change_to_published? && published_before_last_save
  end

  def mark_website_obsolete_git_files
    website.mark_obsolete_git_files
  end

  def prevent_unpublishing_default_language
    return unless website.default_language_id == language_id
    return if published?
    errors.add(:published, :cannot_unpublished_default)
  end
end
