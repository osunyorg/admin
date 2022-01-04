module Communication::Website::WithImport
  extend ActiveSupport::Concern

  included do
    has_one :imported_website,
            class_name: 'Communication::Website::Imported::Website',
            dependent: :destroy
  end

  def import!
    imported_website = Communication::Website::Imported::Website.where(
      website: self, university: university
    ).first_or_create unless imported?

    imported_website.run!
    imported_website
  end

  def imported?
    !imported_website.nil?
  end
end
