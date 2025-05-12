# == Schema Information
#
# Table name: communication_website_post_localizations
#
#  id                       :uuid             not null, primary key
#  featured_image_alt       :string
#  featured_image_credit    :text
#  header_cta               :boolean          default(FALSE)
#  header_cta_label         :string
#  header_cta_url           :string
#  meta_description         :text
#  migration_identifier     :string
#  pinned                   :boolean
#  published                :boolean
#  published_at             :datetime
#  slug                     :string
#  subtitle                 :string
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
#  idx_on_communication_website_id_f6354f61f0                     (communication_website_id)
#  idx_on_university_id_a3a3f1e954                                (university_id)
#  index_communication_website_post_localizations_on_about_id     (about_id)
#  index_communication_website_post_localizations_on_language_id  (language_id)
#
# Foreign Keys
#
#  fk_rails_20680ef99a  (language_id => languages.id)
#  fk_rails_4a9d8c6ad1  (communication_website_id => communication_websites.id)
#  fk_rails_b4db91ebe4  (about_id => communication_website_posts.id)
#  fk_rails_db7d7c515c  (university_id => universities.id)
#
class Communication::Website::Post::Localization < ApplicationRecord
  include AsLocalization
  include Contentful
  include HasGitFiles
  include HeaderCallToAction
  include Initials
  include Permalinkable
  include Sanitizable
  include Shareable
  include WithAccessibility
  include WithBlobs
  include WithFeaturedImage
  include WithOpenApi
  include WithPublication
  include WithUniversity

  belongs_to :website,
              class_name: 'Communication::Website',
              foreign_key: :communication_website_id

  has_summernote :summary
  has_summernote :text # TODO: Remove text attribute

  validates :title, presence: true
  before_validation :set_communication_website_id, on: :create

  def git_path(website)
    return unless website.id == communication_website_id && published && published_at
    git_path_content_prefix(website) + git_path_relative
  end

  def git_path_relative
    "posts/#{published_at.year}/#{published_at.strftime "%Y-%m-%d"}-#{slug}.html"
  end

  def template_static
    "admin/communication/websites/posts/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies
  end

  def authors
    about.authors.map { |author| author.localization_for(language) }.compact
  end

  def categories
    about.categories.ordered.map { |category| category.localization_for(language) }.compact
  end

  def to_detailed_s
    detailed = "#{title}"
    detailed += ", #{subtitle}" if subtitle.present?
    detailed += " — #{published_at ? I18n.l(published_at.to_date) : I18n.t('publication.draft')}"
    if authors.one?
      detailed += ", #{authors.first}"
    elsif authors.many?
      detailed += ", #{authors.collect(&:last_name).to_sentence}"
    end
    detailed
  end

  def to_s
    "#{title}"
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end

  def slug_unavailable?(slug)
    self.class.unscoped
              .where(communication_website_id: self.communication_website_id, language_id: language_id, slug: slug)
              .where.not(id: self.id)
              .exists?
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

  def localize_other_attachments(localization)
    localize_attachment(localization, :shared_image) if shared_image.attached?
  end
end
