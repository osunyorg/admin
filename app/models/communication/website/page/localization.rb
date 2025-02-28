# == Schema Information
#
# Table name: communication_website_page_localizations
#
#  id                       :uuid             not null, primary key
#  breadcrumb_title         :string
#  featured_image_alt       :string
#  featured_image_credit    :text
#  header_cta               :boolean
#  header_cta_label         :string
#  header_cta_url           :string
#  header_text              :text
#  meta_description         :string
#  migration_identifier     :string
#  published                :boolean
#  published_at             :datetime
#  slug                     :string
#  summary                  :text
#  text                     :text
#  title                    :string
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             indexed
#  communication_website_id :uuid             indexed
#  language_id              :uuid             indexed
#  university_id            :uuid             indexed
#
# Indexes
#
#  idx_on_communication_website_id_64c4831480                     (communication_website_id)
#  idx_on_university_id_e62b2aba53                                (university_id)
#  index_communication_website_page_localizations_on_about_id     (about_id)
#  index_communication_website_page_localizations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_20a94720a9  (communication_website_id => communication_websites.id)
#  fk_rails_6845f29842  (about_id => communication_website_pages.id)
#  fk_rails_877bee88b8  (university_id => universities.id)
#  fk_rails_c6b93016c7  (language_id => languages.id)
#
class Communication::Website::Page::Localization < ApplicationRecord
  include AsLocalization
  include AsLocalizedTree
  include Contentful
  include HeaderCallToAction
  include Initials
  include Migratable
  include Permalinkable
  include Sanitizable
  include Shareable
  include WithAccessibility
  include WithBlobs
  include WithFeaturedImage
  include WithGitFiles
  include WithOpenApi
  include WithPublication
  include WithUniversity

  belongs_to  :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  delegate :is_home?, to: :about

  has_summernote :summary

  validates :title, presence: true
  validates :header_cta_label, :header_cta_url, presence: true, if: :header_cta
  before_validation :set_communication_website_id, on: :create
  before_validation :set_published_unless_draftable

  def template_static
    "admin/communication/websites/pages/static"
  end

  def dependencies
    calculated_dependencies = []
    calculated_dependencies += active_storage_blobs
    calculated_dependencies += contents_dependencies
    calculated_dependencies += [website.config_default_content_security_policy]
    unless blocks.published.any?
      # children are used only if there is no block to display
      calculated_dependencies += about.children
    end
    calculated_dependencies
  end

  def best_breadcrumb_title
    breadcrumb_title.presence || title
  end

  def git_path(website)
    return unless website.id == communication_website_id && published
    current_git_path
  end

  # Home        _index.html
  # Page        pages/page-de-test/_index.html
  def git_path_relative
    if about.is_special_page? && about.respond_to?(:git_path_relative)
      about.git_path_relative
    else
      ['pages', slug_with_ancestors_slugs, '_index.html'].compact_blank.join('/')
    end
  end

  def show_toc?
    about.try(:show_toc?) || blocks.template_title.many?
  end

  def to_s
    "#{title}"
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  # La page d'accueil n'a jamais de slug
  def set_slug
    if is_home?
      self.slug = ''
    else
      super
    end
  end

  def skip_slug_validation?
    is_home?
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug)
              .where.not(id: self.id)
              .exists?
  end

  def current_git_path
    @current_git_path ||= git_path_prefix + git_path_relative
  end

  def git_path_prefix
    @git_path_prefix ||= git_path_content_prefix(website)
  end

  def set_communication_website_id
    self.communication_website_id ||= about.communication_website_id
  end

  def explicit_blob_ids
    super.concat [
      featured_image&.blob_id,
      shared_image&.blob_id
    ]
  end

  def inherited_blob_ids
    [best_featured_image&.blob_id]
  end

  def localize_other_attachments(localization)
    localize_attachment(localization, :shared_image) if shared_image.attached?
  end

  # Force publication state if the page is not draftable
  def set_published_unless_draftable
    return if about.draftable?
    self.published = true
  end

end
