module University::WithFeatures
  extend ActiveSupport::Concern

  included do
    # Education
    has_many :features_education_programs, class_name: 'Features::Education::Program', dependent: :destroy

    # Websites
    has_many :features_websites_sites, class_name: 'Features::Websites::Site', dependent: :destroy
  end
end
