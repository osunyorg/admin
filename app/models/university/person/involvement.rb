class University::Person::Involvement < ApplicationRecord
  belongs_to :university
  belongs_to :person
  belongs_to :target
end
