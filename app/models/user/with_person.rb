module User::WithPerson
  extend ActiveSupport::Concern

  included do
    has_one :person, class_name: 'University::Person', dependent: :nullify

    after_create_commit :find_or_create_person unless :server_admin?
  end

  protected

  def find_or_create_person
    person = university.people.where(email: email).first_or_initialize do |person|
      person.first_name = first_name
      person.last_name = last_name
      person.slug = person.to_s.parameterize
      person.phone = mobile_phone
    end
    person.user = self
    person.save
  end
end
