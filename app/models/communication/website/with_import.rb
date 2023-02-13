module Communication::Website::WithImport
  extend ActiveSupport::Concern

  included do
    has_one :imported_website,
            class_name: 'Communication::Website::Imported::Website',
            dependent: :destroy
  end

  def import!
    create_imported_website(university: university) unless imported?
    imported_website.run!
    reload
  end

  def imported?
    !imported_website.nil?
  end
end
