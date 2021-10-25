# == Schema Information
#
# Table name: users
#
#  id                            :uuid             not null, primary key
#  confirmation_sent_at          :datetime
#  confirmation_token            :string
#  confirmed_at                  :datetime
#  current_sign_in_at            :datetime
#  current_sign_in_ip            :string
#  direct_otp                    :string
#  direct_otp_sent_at            :datetime
#  email                         :string           default(""), not null
#  encrypted_otp_secret_key      :string
#  encrypted_otp_secret_key_iv   :string
#  encrypted_otp_secret_key_salt :string
#  encrypted_password            :string           default(""), not null
#  failed_attempts               :integer          default(0), not null
#  first_name                    :string
#  last_name                     :string
#  last_sign_in_at               :datetime
#  last_sign_in_ip               :string
#  locked_at                     :datetime
#  mobile_phone                  :string
#  remember_created_at           :datetime
#  reset_password_sent_at        :datetime
#  reset_password_token          :string
#  role                          :integer          default("visitor")
#  second_factor_attempts_count  :integer          default(0)
#  session_token                 :string
#  sign_in_count                 :integer          default(0), not null
#  totp_timestamp                :datetime
#  unconfirmed_email             :string
#  unlock_token                  :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  language_id                   :uuid
#  university_id                 :uuid             not null
#
# Indexes
#
#  index_users_on_confirmation_token        (confirmation_token) UNIQUE
#  index_users_on_email_and_university_id   (email,university_id) UNIQUE
#  index_users_on_encrypted_otp_secret_key  (encrypted_otp_secret_key) UNIQUE
#  index_users_on_language_id               (language_id)
#  index_users_on_reset_password_token      (reset_password_token) UNIQUE
#  index_users_on_university_id             (university_id)
#  index_users_on_unlock_token              (unlock_token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (university_id => universities.id)
#
class User < ApplicationRecord
  # In this order, "resize avatar" callback will be fired after the others.
  include WithAvatar
  include WithAuthentication
  include WithRoles
  include WithSyncBetweenUniversities

  belongs_to :university
  belongs_to :language
  has_one :researcher, class_name: 'Research::Researcher'

  scope :ordered, -> { order(:last_name, :first_name) }

  def to_s
    "#{first_name} #{last_name}"
  end
end
