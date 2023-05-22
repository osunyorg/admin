# == Schema Information
#
# Table name: education_diplomas
#
#  id            :uuid             not null, primary key
#  duration      :text
#  ects          :integer
#  level         :integer          default("not_applicable")
#  name          :string
#  short_name    :string
#  slug          :string
#  summary       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  university_id :uuid             not null, indexed
#
# Indexes
#
#  index_education_diplomas_on_university_id  (university_id)
#
# Foreign Keys
#
#  fk_rails_6cb2e9fa90  (university_id => universities.id)
#
class Education::Diploma < ApplicationRecord
  include Sanitizable
  include WithBlocks
  include WithGit
  include WithPermalink
  include WithSlug
  include WithUniversity

  has_many :programs, dependent: :nullify

  scope :ordered, -> { order(:level, :name) }

  enum level: {
    not_applicable: 0,
    primary: 40,
    secondary: 60,
    high: 80,
    first_year: 100,
    second_year: 200,
    third_year: 300,
    fourth_year: 400,
    master: 500,
    doctor: 800
  }

  def websites
    @websites ||= university.websites.reject { |website|
      !for_website?(website)
    }
  end

  def programs_for_website(website)
    website.education_programs.where(diploma: self)
  end

  def published_programs_for_website(website)
    programs_for_website(website).published
  end

  # We need to send the diplomas only to the websites that need them
  def for_website?(website)
    published_programs_for_website(website).any?
  end

  def git_path(website)
    "#{git_path_content_prefix(website)}diplomas/#{slug}/_index.html" if for_website?(website)
  end

  def git_dependencies(website)
    website_programs = programs_for_website(website)

    dependencies = [self]
    dependencies += git_block_dependencies
    dependencies += website_programs + website_programs.map(&:active_storage_blobs).flatten
    dependencies
  end

  def to_s
    "#{name}"
  end
end
