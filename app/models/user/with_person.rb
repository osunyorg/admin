module User::WithPerson
  extend ActiveSupport::Concern

  included do
    # Original person
    has_one :person, class_name: 'University::Person', dependent: :nullify

    delegate :experiences, to: :person

    after_save_commit :sync_person, if: :person
    after_create_commit :find_or_create_person, unless: :server_admin?
  end

  protected

  def find_or_create_person
    person = university.people.where(email: email).first || university.people.new
    person.localizations.build(
      first_name: first_name,
      last_name: last_name,
      user: self,
      language_id: university.default_language_id
    )
    person.save
  end

  def sync_person
    person_l10n = person.original_localization
    person_l10n.first_name = first_name
    person_l10n.last_name = last_name
    person_l10n.slug =person_l10n.to_s.parameterize
    person_l10n.save
    person.picture.purge if picture_infos.present? && person.picture&.attached?
    person.save
  end
end
