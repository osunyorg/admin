# == Schema Information
#
# Table name: education_program_localizations
#
#  id                     :uuid             not null, primary key
#  accessibility          :text
#  contacts               :text
#  content                :text
#  deleted_at             :datetime
#  duration               :string
#  evaluation             :text
#  featured_image_credit  :text
#  featured_media_alt     :string
#  meta_description       :text
#  name                   :string
#  objectives             :text
#  opportunities          :text
#  other                  :text
#  path                   :string
#  pedagogy               :text
#  prerequisites          :text
#  presentation           :text
#  pricing                :text
#  pricing_apprenticeship :text
#  pricing_continuing     :text
#  pricing_initial        :text
#  published              :boolean          default(FALSE)
#  published_at           :datetime
#  qualiopi_text          :text
#  registration           :text
#  registration_url       :string
#  results                :text
#  short_name             :string
#  slug                   :string
#  summary                :text
#  url                    :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  about_id               :uuid             uniquely indexed => [language_id], indexed
#  featured_media_id      :uuid             indexed
#  language_id            :uuid             uniquely indexed => [about_id], indexed
#  university_id          :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_9b56b45e58                      (about_id,language_id) UNIQUE
#  index_education_program_localizations_on_about_id           (about_id)
#  index_education_program_localizations_on_featured_media_id  (featured_media_id)
#  index_education_program_localizations_on_language_id        (language_id)
#  index_education_program_localizations_on_university_id      (university_id)
#
# Foreign Keys
#
#  fk_rails_3e759230aa  (about_id => education_programs.id)
#  fk_rails_66267db4ba  (language_id => languages.id)
#  fk_rails_c59b2050d6  (featured_media_id => communication_medias.id) ON DELETE => nullify
#  fk_rails_e375f2df91  (university_id => universities.id)
#
class Education::Program::Localization < ApplicationRecord
  acts_as_paranoid

  include Accessible
  include AsLocalization
  include AsLocalizedTree # ordered scope is overridden below
  include Contentful
  include HasBlobs
  include HasFeaturedMedia
  include HasGitFiles
  include HasUniversity
  include Initials
  include Pathable
  include Permalinkable
  include Publishable
  include Sanitizable
  include Shareable
  include WithInheritance

  has_summernote :summary
  has_summernote :presentation
  has_one_attached_deletable :logo
  rich_text_areas_with_inheritance  :accessibility,
                                    :contacts,
                                    :evaluation,
                                    :objectives,
                                    :opportunities,
                                    :other,
                                    :pedagogy,
                                    :prerequisites,
                                    :pricing,
                                    :pricing_apprenticeship,
                                    :pricing_continuing,
                                    :pricing_initial,
                                    :registration,
                                    :content,
                                    :results

  validates :name, presence: true
  validates :logo, size: { less_than: 5.megabytes }

  scope :ordered, -> (language = nil) { order(:slug) }

  def git_path_relative
    # Path has always trailing and leading slashes
    "programs#{path}_index.html"
  end

  def should_sync_to?(website)
    website.active_language_ids.include?(language_id) &&
    website.has_connected_object?(self) &&
    published?
  end

  def template_static
    "admin/education/programs/static"
  end

  def dependencies
    active_storage_blobs +
    contents_dependencies +
    [
      diploma,
      downloadable_summary
    ]
  end

  def blocks_heading_rank_base
    3
  end

  def explicit_blob_ids
    super.concat [
      featured_blob_id,
      shared_image&.blob_id,
      downloadable_summary&.original_blob_id,
      logo&.blob_id
    ]
  end

  def inherited_blob_ids
    [featured_blob&.id]
  end

  def downloadable_summary
    return if about.downloadable_summary.nil?
    about.downloadable_summary.best_localization_for(language)
  end

  def diploma
    return if about.diploma.nil?
    about.diploma.best_localization_for(language)
  end

  def schools
    @schools ||= about.schools
                      .ordered(language)
                      .map { |school| school.localization_for(language) }
                      .compact
  end

  def parent
    return if about.parent.nil?
    about.parent.best_localization_for(language)
  end

  # Override Staticable to add diploma between special page and program's ancestors
  # Example: IUT de Bordeaux > Formations > BUT > Génie biologique > Agronomie
  def hugo_ancestors(website)
    ancestors = []
    ancestors.concat hugo_ancestors_for_special_page(website)
    ancestors << diploma if diploma.present?
    ancestors.concat self.ancestors if respond_to?(:ancestors)
    ancestors.compact
  end

  def to_short_s
    short_name.blank? ? to_s : short_name
  end

  def to_s
    "#{name}"
  end

  protected

  def check_accessibility
    accessibility_merge_array blocks
  end
end
