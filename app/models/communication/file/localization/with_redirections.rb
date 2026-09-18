module Communication::File::Localization::WithRedirections
  extend ActiveSupport::Concern

  included do
    has_many  :redirections,
              class_name: 'Communication::File::Redirection',
              foreign_key: :communication_file_localization_id,
              dependent: :destroy
  end
end