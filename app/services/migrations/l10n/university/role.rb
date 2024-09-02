class Migrations::L10n::University::Role < Migrations::L10n::Base
  def self.execute
    migrate_localizations
  end

  def self.migrate_localizations
    University::Role.find_each do |role|
      # If "old way" translation, we set the about to the original, else if "old way" master, we take its ID.
      about_id = role.original_id || role.id

      next if University::Role::Localization.where(
        about_id: about_id,
        language_id: role.language_id
      ).exists?

      l10n = University::Role::Localization.create(
        description: role.description,
        about_id: about_id,
        language_id: role.language_id,
        university_id: role.university_id,
        created_at: role.created_at
      )

      if role.original_id.nil?
        # This role will still exist as master.
        # We need to make sure the target is the original.
        # Can be an Education::School or an Education::Program
        if role.target.present?
          target_id = role.target.original_id || role.target.id
          role.update_column(:target_id, target_id)
        end
      end
    end
  end
end