module User::WithPerson
  extend ActiveSupport::Concern

  included do
    has_one :person, class_name: 'University::Person', dependent: :nullify

    delegate :experiences, to: :person

    after_save_commit :sync_person, if: :person
    after_create_commit :find_or_create_person, unless: :server_admin?
  end

  protected

  def find_or_create_person
    person = university.people.where(email: email).first || university.people.new
    person.first_name = first_name
    person.last_name = last_name
    person.slug = person.to_s.parameterize
    person.user = self
    person.save
  end

  def sync_person
    person.first_name = first_name
    person.last_name = last_name
    person.slug = person.to_s.parameterize
    person.picture.purge if picture_infos.present? && person.picture&.attached?
    person.save
  end
end
