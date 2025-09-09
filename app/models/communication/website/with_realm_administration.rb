module Communication::Website::WithRealmAdministration
  extend ActiveSupport::Concern

  def administrators
    has_administrators? ? about.administrators : University::Person.none
  end

  def administration_locations
    has_administration_locations? ? about.administration_locations : Administration::Location.none
  end

  def has_administrators?
    about && about.has_administrators?
  end

  def has_administration_locations?
    about && about.has_administration_locations?
  end

end