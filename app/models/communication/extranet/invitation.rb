# == Schema Information
#
# Table name: communication_extranet_invitations
#
#  id            :uuid             not null, primary key
#  from_email    :string
#  from_name     :string
#  message       :text
#  to_email      :string
#  to_name       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  extranet_id   :uuid             indexed
#  person_id     :uuid             indexed
#  university_id :uuid             indexed
#  user_id       :uuid             indexed
#
# Indexes
#
#  index_communication_extranet_invitations_on_extranet_id    (extranet_id)
#  index_communication_extranet_invitations_on_person_id      (person_id)
#  index_communication_extranet_invitations_on_university_id  (university_id)
#  index_communication_extranet_invitations_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_2a0ba0dd0d  (university_id => universities.id)
#  fk_rails_85c1d16bbf  (user_id => users.id)
#  fk_rails_989e9a94ca  (person_id => university_people.id)
#  fk_rails_e064970cc5  (extranet_id => communication_extranets.id)
#
class Communication::Extranet::Invitation < ApplicationRecord
  include Sanitizable
  include WithUniversity

  belongs_to :extranet, class_name: 'Communication::Extranet'
  belongs_to :user
  belongs_to :person, class_name: 'University::Person'
  validates :from_name, :from_email, :to_name, :to_email, :message, presence: true
  validate :can_send_to_person, on: :create
  validates :to_email, :from_email, format: { with: Devise.email_regexp }

  after_create_commit :send_invitation_email

  def self.sendable_to?(person)
    self.where(person: person).where('created_at >= ?', University::Person::WithAlumnus::DELAY_FOR_INVITATION.ago).none?
  end

  private

  def can_send_to_person
    unless self.class.sendable_to?(person)
      errors.add(:to_email, :too_soon)
    end
  end

  def send_invitation_email
    # TODO
    # Communication::Extranet::InvitationMailer.with(invitation: self).invitation_email.deliver_later
  end

end
