# == Schema Information
#
# Table name: users
#
#  id                            :uuid             not null, primary key
#  admin_theme                   :integer          default("pure")
#  confirmation_sent_at          :datetime
#  confirmation_token            :string           indexed
#  confirmed_at                  :datetime
#  current_sign_in_at            :datetime
#  current_sign_in_ip            :string
#  direct_otp                    :string
#  direct_otp_delivery_method    :string
#  direct_otp_sent_at            :datetime
#  email                         :string           default(""), not null, indexed => [university_id]
#  encrypted_otp_secret_key      :string           indexed
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
#  picture_url                   :string
#  remember_created_at           :datetime
#  reset_password_sent_at        :datetime
#  reset_password_token          :string           indexed
#  role                          :integer          default("visitor")
#  second_factor_attempts_count  :integer          default(0)
#  session_token                 :string
#  sign_in_count                 :integer          default(0), not null
#  totp_timestamp                :datetime
#  unconfirmed_email             :string
#  unlock_token                  :string           indexed
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  language_id                   :uuid             indexed
#  university_id                 :uuid             not null, indexed => [email], indexed
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
#  fk_rails_45f4f12508  (language_id => languages.id)
#  fk_rails_bd6f7212a9  (university_id => universities.id)
#
class User < ApplicationRecord
  # We don't include Sanitizable because too many complex attributes.
  # The sanitization is handled in User::WithAuthentication's sanitize_fields method.
  include WithAdminTheme
  include WithAuthentication
  include WithAuthorship
  include WithAvatar
  include WithFavorites
  include WithOmniauth
  include WithPerson
  include WithRegistrationContext
  include WithRoles
  include WithSyncBetweenUniversities
  include WithUniversity

  belongs_to :language

  scope :ordered, -> { order(:last_name, :first_name) }
  scope :for_language, -> (language_id) { where(language_id: language_id) }
  scope :for_search_term, -> (term) {
    where("
      unaccent(concat(users.first_name, ' ', users.last_name)) ILIKE unaccent(:term) OR
      unaccent(concat(users.last_name, ' ', users.first_name)) ILIKE unaccent(:term) OR
      unaccent(users.first_name) ILIKE unaccent(:term) OR
      unaccent(users.last_name) ILIKE unaccent(:term) OR
      unaccent(users.email) ILIKE unaccent(:term) OR
      unaccent(users.mobile_phone) ILIKE unaccent(:term)
    ", term: "%#{sanitize_sql_like(term)}%")
  }

  def to_s
    "#{first_name} #{last_name}"
  end

end
