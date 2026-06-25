# == Schema Information
#
# Table name: communication_extranet_invitations
#
#  id            :uuid             not null, primary key
#  accepted_at   :datetime
#  sent_at       :datetime
#  token         :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  creator_id    :uuid             indexed
#  extranet_id   :uuid             not null, indexed
#  person_id     :uuid             not null, indexed
#  university_id :uuid             not null, indexed
#  user_id       :uuid             indexed
#
# Indexes
#
#  index_communication_extranet_invitations_on_creator_id     (creator_id)
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
#  fk_rails_c1af12077b  (creator_id => users.id)
#  fk_rails_e064970cc5  (extranet_id => communication_extranets.id)
#
class Communication::Extranet::Invitation < ApplicationRecord
  TOKEN_LENGTH = 30

  include WithUniversity

  belongs_to :extranet, class_name: "Communication::Extranet"
  belongs_to :person, class_name: "University::Person"
  belongs_to :user, optional: true
  belongs_to :creator, class_name: "User", optional: true

  validates :email, :token, presence: true

  before_validation :generate_token, on: :create
  after_commit :send_email, on: :create

  protected

  def generate_token
    self.token = SecureRandom.base64(TOKEN_LENGTH)
  end

  def send_email
    # TODO: Send email with the creator in CC
  end
end
