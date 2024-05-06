module University::Person::WithPersonalData
  extend ActiveSupport::Concern

  VISIBILITY_ENUM = { private: 0, restricted: 10, public: 20 }

  included do
    enum address_visibility:            VISIBILITY_ENUM, _prefix: :address_is
    enum linkedin_visibility:           VISIBILITY_ENUM, _prefix: :linkedin_is
    enum twitter_visibility:            VISIBILITY_ENUM, _prefix: :twitter_is
    enum mastodon_visibility:           VISIBILITY_ENUM, _prefix: :mastodon_is
    enum phone_mobile_visibility:       VISIBILITY_ENUM, _prefix: :phone_mobile_is
    enum phone_professional_visibility: VISIBILITY_ENUM, _prefix: :phone_professional_is
    enum phone_personal_visibility:     VISIBILITY_ENUM, _prefix: :phone_personal_is
    enum email_visibility:              VISIBILITY_ENUM, _prefix: :email_is

    validates :address_visibility,
              :linkedin_visibility,
              :twitter_visibility,
              :mastodon_visibility,
              :phone_mobile_visibility,
              :phone_professional_visibility,
              :phone_personal_visibility,
              :email_visibility,
              presence: true
  end
end