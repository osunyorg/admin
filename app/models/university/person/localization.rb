# == Schema Information
#
# Table name: university_person_localizations
#
#  id               :uuid             not null, primary key
#  biography        :text
#  first_name       :string
#  last_name        :string
#  linkedin         :string
#  mastodon         :string
#  meta_description :text
#  name             :string
#  picture_credit   :text
#  slug             :string           indexed
#  summary          :text
#  twitter          :string
#  url              :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  about_id         :uuid             indexed
#  language_id      :uuid             indexed
#  university_id    :uuid             indexed
#
# Indexes
#
#  index_university_person_localizations_on_about_id       (about_id)
#  index_university_person_localizations_on_language_id    (language_id)
#  index_university_person_localizations_on_slug           (slug)
#  index_university_person_localizations_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_469b2f6a6f  (about_id => university_people.id)
#  fk_rails_5eca3fe920  (university_id => universities.id)
#  fk_rails_bf16824595  (language_id => languages.id)
#
class University::Person::Localization < ApplicationRecord
  include AsLocalization
  include Backlinkable
  include Contentful
  include Permalinkable
  include Sanitizable
  include WithGitFiles
  include WithUniversity

  alias :person :about

  delegate :featured_image, to: :person

  has_summernote :summary
  has_summernote :biography

  validates :first_name, :last_name, presence: true
  before_validation :prepare_name

  def person_l10n
    @person_l10n ||= University::Person::Localization.find(id)
  end

  def administrator
    @administrator ||= University::Person::Localization::Administrator.find(id)
  end

  def author
    @author ||= University::Person::Localization::Author.find(id)
  end

  def researcher
    @researcher ||= University::Person::Localization::Researcher.find(id)
  end

  def teacher
    @teacher ||= University::Person::Localization::Teacher.find(id)
  end

  def dependencies
    contents_dependencies
  end

  def references
    [administrator, author, researcher, teacher]
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}persons/#{slug}.html" if for_website?(website)
  end

  def template_static
    "admin/university/people/static"
  end

  def to_s
    "#{first_name} #{last_name}"
  end

  def to_s_with_mail
    about.email.present? ? "#{to_s} (#{about.email})" : to_s
  end

  def to_s_alphabetical
    "#{last_name} #{first_name}"
  end

  def initials
    "#{first_name.to_s.first}#{last_name.to_s.first}"
  end

  def published?
    persisted?
  end

  # user in statics where we don't need the cateogries not localized
  def categories
    about.categories.ordered.map { |category| category.localization_for(language) }.compact
  end

  protected

  def backlinks_blocks(website)
    website.blocks.template_persons
  end

  def prepare_name
    self.name = to_s
  end

end
