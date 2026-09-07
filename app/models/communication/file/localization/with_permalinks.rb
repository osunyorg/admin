module Communication::File::Localization::WithPermalinks
  extend ActiveSupport::Concern

  included do
    has_many  :permalinks,
              foreign_key: :communication_file_localization_id,
              dependent: :destroy
  end

  def current_permalink
    permalinks.current.first
  end

  def previous_permalinks
    permalinks.not_current.ordered
  end
end