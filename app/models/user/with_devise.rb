module User::WithDevise
  extend ActiveSupport::Concern

  included do
    devise  :database_authenticatable, :registerable, :recoverable, :rememberable

    def self.find_for_authentication(warden_conditions)
      where(email: warden_conditions[:email].downcase, university_id: warden_conditions[:university_id]).first
    end
  end
end
