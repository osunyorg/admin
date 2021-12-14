module University::WithAdministration
  extend ActiveSupport::Concern

  included do
    has_many :members, class_name: 'Administration::Member', dependent: :destroy
  end
end
