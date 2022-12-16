# == Schema Information
#
# Table name: communication_website_permalinks
#
#  id            :uuid             not null, primary key
#  about_type    :string           not null
#  is_current    :boolean          default(TRUE)
#  path          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  about_id      :uuid             not null
#  university_id :uuid             not null, indexed
#  website_id    :uuid             not null, indexed
#
# Indexes
#
#  index_communication_website_permalinks_on_university_id  (university_id)
#  index_communication_website_permalinks_on_website_id     (website_id)
#
# Foreign Keys
#
#  fk_rails_e9646cce64  (university_id => universities.id)
#  fk_rails_f389ba7d45  (website_id => communication_websites.id)
#
class Communication::Website::Permalink < ApplicationRecord
  MAPPING = {
    "Communication::Website::Category" => Communication::Website::Permalink::Category,
    "Communication::Website::Page" => Communication::Website::Permalink::Page,
    "Communication::Website::Post" => Communication::Website::Permalink::Post,
    "Education::Diploma" => Communication::Website::Permalink::Diploma,
    "Education::Program" => Communication::Website::Permalink::Program,
    "University::Organization" => Communication::Website::Permalink::Organization,
    "University::Person" => Communication::Website::Permalink::Person,
    "University::Person::Administrator" => Communication::Website::Permalink::Administrator,
    "University::Person::Author" => Communication::Website::Permalink::Author,
    "University::Person::Researcher" => Communication::Website::Permalink::Researcher,
    "University::Person::Teacher" => Communication::Website::Permalink::Teacher
  }

  include WithUniversity

  belongs_to :university
  belongs_to :website, class_name: "Communication::Website"
  belongs_to :about, polymorphic: true

  validates :about_id, :about_type, :path, presence: true

  before_validation :set_university, on: :create

  scope :for_website, -> (website) { where(website_id: website.id) }
  scope :current, -> { where(is_current: true) }
  scope :not_current, -> { where(is_current: false) }

  def self.config_in_website(website)
    required_kinds_in_website(website).map { |permalink_class|
      [permalink_class.static_config_key, permalink_class.pattern_in_website(website)]
    }.to_h
  end

  def self.for_object(object, website)
    permalink_class = MAPPING[object.class.to_s]
    raise ArgumentError.new("Permalinks do not handle an object of type #{object.class.to_s}") if permalink_class.nil?
    permalink_class.new(website: website, about: object)
  end

  # Can be overwritten
  def self.required_in_config?(website)
    false
  end

  def self.supported_by?(object)
    MAPPING.keys.include?(object.class.to_s)
  end

  def self.pattern_in_website(website)
    raise NotImplementedError
  end

  def pattern
    self.class.pattern_in_website(website)
  end

  def computed_path
    return nil unless published?
    @computed_path ||= Static.clean_path(published_path)
  end

  def save_if_needed
    current_permalink = about.current_permalink_in_website(website)

    # If the object had no permalink or if its path changed, we create a new permalink
    if computed_path.present? && (current_permalink.nil? || current_permalink.path != computed_path)
      self.path = computed_path
      current_permalink&.update(is_current: false) if save
    end
  end

  protected

  def self.required_kinds_in_website(website)
    MAPPING.values.select { |permalink_class|
      permalink_class.required_in_config?(website)
    }
  end

  # Can be overwritten (Page for example)
  def published_path
    # TODO I18n doit prendre la langue du about
    p = ""
    p += "/#{website.default_language.iso_code}" if website.languages.many?
    p += pattern
    substitutions.each do |key, value|
      p.gsub! ":#{key}", "#{value}"
    end
    p
  end

  # Can be overwritten
  def published?
    about.for_website?(website)
  end

  # Can be overwritten
  def substitutions
    {
      slug: about.slug
    }
  end

  def set_university
    self.university_id = website.university_id
  end

end
