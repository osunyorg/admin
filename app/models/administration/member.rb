# == Schema Information
#
# Table name: administration_members
#
#  id                :uuid             not null, primary key
#  email             :string
#  first_name        :string
#  is_administrative :boolean
#  is_author         :boolean
#  is_researcher     :boolean
#  is_teacher        :boolean
#  last_name         :string
#  phone             :string
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  university_id     :uuid             not null
#  user_id           :uuid
#
# Indexes
#
#  index_administration_members_on_university_id  (university_id)
#  index_administration_members_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (university_id => universities.id)
#  fk_rails_...  (user_id => users.id)
#
class Administration::Member < ApplicationRecord
  include WithGithubFiles
  include WithSlug

  has_rich_text :biography

  belongs_to :university
  belongs_to :user, optional: true

  has_many :communication_website_posts,
           class_name: 'Communication::Website::Post',
           foreign_key: :author_id,
           dependent: :nullify

  has_and_belongs_to_many :research_journal_articles,
                          class_name: 'Research::Journal::Article',
                          join_table: :research_journal_articles_researchers,
                          foreign_key: :researcher_id

  has_and_belongs_to_many :education_programs,
                          class_name: 'Education::Program',
                          join_table: :education_programs_teachers,
                          foreign_key: :education_teacher_id,
                          association_foreign_key: :education_program_id

  validates_presence_of :first_name, :last_name
  validates_uniqueness_of :email, scope: :university_id, allow_blank: true, if: :will_save_change_to_email?
  validates_format_of :email, with: Devise::email_regexp, allow_blank: true, if: :will_save_change_to_email?


  scope :ordered, -> { order(:last_name, :first_name) }
  scope :administratives, -> { where(is_administrative: true) }
  scope :authors, -> { where(is_author: true) }
  scope :teachers, -> { where(is_teacher: true) }
  scope :researchers, -> { where(is_researcher: true) }

  def to_s
    "#{last_name} #{first_name}"
  end

  def websites
    []
    # TODO
  end

end
