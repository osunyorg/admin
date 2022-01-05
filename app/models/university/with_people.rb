module University::WithPeople
  extend ActiveSupport::Concern

  included do
    has_many :people, class_name: 'University::Person', dependent: :destroy
  end
end
