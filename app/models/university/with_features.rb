module University::WithFeatures
  extend ActiveSupport::Concern

  included do
    has_many :features_websites_sites, class_name: 'Features::Websites::Site', dependent: :destroy

    has_many :features_education_programs, class_name: 'Features::Education::Program', dependent: :destroy
  end
end
