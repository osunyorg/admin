module Migratable
  extend ActiveSupport::Concern

  included do
    validate :migration_identifier_must_be_unique, if: -> { migration_identifier.present? }
  end

  protected

  def migration_identifier_unavailable?
    existence_params = { migration_identifier: migration_identifier }
    existence_params[:university_id] = self.university_id if respond_to?(:university_id)
    self.class.unscoped
              .where(**existence_params)
              .where.not(id: self.id)
              .exists?
  end

  def migration_identifier_must_be_unique
    errors.add(:migration_identifier, :taken) if migration_identifier_unavailable?
  end
end