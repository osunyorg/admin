module Education::Program::WithDiploma
  extend ActiveSupport::Concern

  included do
    belongs_to :diploma,
      class_name: 'Education::Diploma',
      optional: true
  end

  # Used by website 
  # https://github.com/noesya/osuny/issues/1529
  def diplomas
    [diploma]
  end
end
