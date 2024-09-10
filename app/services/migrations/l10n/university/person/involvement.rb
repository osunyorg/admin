class Migrations::L10n::University::Person::Involvement < Migrations::L10n::Base
  def self.execute
    migrate_localizations
  end

  def self.migrate_localizations
    University::Person::Involvement.where(self.constraint).find_each do |involvement|
      language_id = involvement.person.language_id
      l10n = University::Person::Involvement::Localization.create(
        description: involvement.description,
        about_id: involvement.id,
        language_id: language_id,
        university_id: involvement.university_id,
        created_at: involvement.created_at
      )

      if involvement.original_id.nil?
        # This role will still exist as master.
        # We need to make sure the target is the original.
        # Can be an Education::Program, a Research::Laboratory, or a University::Role (attached to Programs or Schools)
        if involvement.target.present? && involvement.target_type != "Research::Laboratory" # TODO L10N : Remove this condition when Research::Laboratory is localized
          target_id = involvement.target.original_id || involvement.target.id
          involvement.update_column(:target_id, target_id)
        end
      end
    end
  end
end
