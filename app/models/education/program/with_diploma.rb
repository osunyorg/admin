module Education::Program::WithDiploma
  extend ActiveSupport::Concern

  included do
    belongs_to :diploma,
      class_name: 'Education::Diploma',
      optional: true
  end
end
