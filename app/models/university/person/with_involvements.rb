module University::Person::WithInvolvements
  extend ActiveSupport::Concern

  included do
    has_many  :involvements,
              class_name: 'University::Person::Involvement',
              dependent: :destroy

    accepts_nested_attributes_for :involvements
  end
end
