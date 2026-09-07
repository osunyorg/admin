# == Schema Information
#
# Table name: university_person_localizations
#
#  id                    :uuid             not null, primary key
#  biography             :text
#  deleted_at            :datetime
#  featured_image_credit :text
#  featured_media_alt    :text
#  first_name            :string
#  last_name             :string
#  linkedin              :string
#  mastodon              :string
#  meta_description      :text
#  name                  :string
#  picture_credit        :text
#  published             :boolean          default(TRUE)
#  published_at          :datetime
#  slug                  :string           indexed
#  summary               :text
#  twitter               :string
#  url                   :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  about_id              :uuid             uniquely indexed => [language_id], indexed
#  featured_media_id     :uuid             indexed
#  language_id           :uuid             uniquely indexed => [about_id], indexed
#  university_id         :uuid             indexed
#
# Indexes
#
#  idx_on_about_id_language_id_54757d0dad                      (about_id,language_id) UNIQUE
#  index_university_person_localizations_on_about_id           (about_id)
#  index_university_person_localizations_on_featured_media_id  (featured_media_id)
#  index_university_person_localizations_on_language_id        (language_id)
#  index_university_person_localizations_on_slug               (slug)
#  index_university_person_localizations_on_university_id      (university_id)
#
# Foreign Keys
#
#  fk_rails_469b2f6a6f  (about_id => university_people.id)
#  fk_rails_5eca3fe920  (university_id => universities.id)
#  fk_rails_bf16824595  (language_id => languages.id)
#  fk_rails_f217ecfb87  (featured_media_id => communication_medias.id) ON DELETE => nullify
#
class University::Person::Localization < ApplicationRecord
  acts_as_paranoid

  include AsLocalization
  include Backlinkable
  include Contentful
  include HasBlobs
  include HasFeaturedMedia # TODO Arnaud: Future feature of person's cover image
  include HasGitFiles
  include HasUniversity
  include Permalinkable
  include Publishable
  include Sanitizable

  has_summernote :summary
  has_summernote :biography

  validates :last_name, presence: true
  before_validation :prepare_name

  def about
    University::Person.unscoped { super }
  end
  alias person about

  # Persons have no featured media yet, their picture is used as illustration
  def featured_blob
    person.best_picture.attached? ? person.best_picture.blob
                                  : super
  end

  def person_l10n
    @person_l10n ||= University::Person::Localization.with_deleted.find(id)
  end

  def administrator
    @administrator ||= University::Person::Localization::Administrator.with_deleted.find(id)
  end

  def author
    @author ||= University::Person::Localization::Author.with_deleted.find(id)
  end

  def researcher
    @researcher ||= University::Person::Localization::Researcher.with_deleted.find(id)
  end

  def teacher
    @teacher ||= University::Person::Localization::Teacher.with_deleted.find(id)
  end

  def dependencies
    person.active_storage_blobs +
    contents_dependencies
  end

  def references
    super +
    [administrator, author, researcher, teacher]
  end

  def git_path_relative
    "persons/#{slug}.html"
  end

  def template_static
    "admin/university/people/static"
  end

  def to_s
    "#{first_name} #{last_name}".strip
  end

  def to_s_with_mail
    about.email.present? ? "#{to_s} (#{about.email})" : to_s
  end

  def to_s_alphabetical
    "#{last_name} #{first_name}".strip
  end

  def initials
    "#{first_name.to_s.first}#{last_name.to_s.first}"
  end


  # user in statics where we don't need the cateogries not localized
  def categories
    about.categories.ordered.map { |category| category.localization_for(language) }.compact
  end

  def explicit_blob_ids
    [
      picture&.blob_id,
      featured_blob&.id
    ]
  end

  protected

  def backlinks_blocks(website)
    website.blocks.template_persons
  end

  def prepare_name
    self.name = to_s
  end

end
