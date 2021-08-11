module University::WithFeatureEducation
  extend ActiveSupport::Concern

  included do
    has_many :features_education_programs, class_name: 'Features::Education::Program', dependent: :destroy
  end
end
