# == Schema Information
#
# Table name: communication_website_content_federations
#
#  id                       :uuid             not null, primary key
#  about_type               :string           not null, indexed => [about_id]
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  about_id                 :uuid             not null, indexed => [about_type]
#  communication_website_id :uuid             not null, indexed
#  destination_website_id   :uuid             not null, indexed
#  university_id            :uuid             not null, indexed
#
# Indexes
#
#  idx_on_communication_website_id_ca52307519                (communication_website_id)
#  idx_on_destination_website_id_2ef67cad17                  (destination_website_id)
#  idx_on_university_id_04037a794f                           (university_id)
#  index_communication_website_content_federations_on_about  (about_type,about_id)
#
# Foreign Keys
#
#  fk_rails_8a2b4558b4  (destination_website_id => communication_websites.id)
#  fk_rails_9eff17afef  (communication_website_id => communication_websites.id)
#  fk_rails_ab48a3445f  (university_id => universities.id)
#
class Communication::Website::ContentFederation < ApplicationRecord
  include WithUniversity

  belongs_to  :website,
              class_name: "Communication::Website",
              foreign_key: :communication_website_id
  belongs_to  :destination_website,
              class_name: "Communication::Website",
              foreign_key: :destination_website_id
  belongs_to :about, polymorphic: true

  before_validation :set_website_and_university, on: :create

  protected

  def set_website_and_university
    self.communication_website_id = about.communication_website_id
    self.university_id = about.university_id
  end
end
