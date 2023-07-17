# == Schema Information
#
# Table name: emergency_messages
#
#  id              :uuid             not null, primary key
#  content_en      :text
#  content_fr      :text
#  delivered_at    :datetime
#  delivered_count :integer
#  name            :string
#  role            :string
#  subject_en      :string
#  subject_fr      :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  university_id   :uuid             indexed
#
# Indexes
#
#  index_emergency_messages_on_university_id  (university_id) WHERE (university_id IS NOT NULL)
#
# Foreign Keys
#
#  fk_rails_3bd377a11a  (university_id => universities.id)
#
class EmergencyMessage < ApplicationRecord
  belongs_to :university, optional: true

  validates :name, :subject_fr, :subject_en, :content_fr, :content_en, presence: true

  def deliver!
    users_fr = target.where(language_id: Language.find_by(iso_code: 'fr').id)
    users_fr.each do |user|
      NotificationMailer.emergency_message(self, user, 'fr').deliver_later
    end
    # other users fallback to :en
    users_en = target.where.not(language_id: Language.find_by(iso_code: 'fr').id)
    users_en.each do |user|
      NotificationMailer.emergency_message(self, user, 'en').deliver_later
    end
    update(delivered_at: Time.now, delivered_count: target.size)
  end

  def delivered?
    delivered_at.present?
  end

  def to_s
    "#{name}"
  end

  def target
    users = User.all
    users = users.where(university_id: university_id) if university_id.present? 
    users = users.where(role: role) if role.present?
    users
  end

end
