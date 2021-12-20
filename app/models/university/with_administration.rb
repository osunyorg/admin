module University::WithAdministration
  extend ActiveSupport::Concern

  included do
    has_many :administration_members, class_name: 'Administration::Member', dependent: :destroy
  end
end
