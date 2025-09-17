# Means there might be a website about this object
# https://iut-perigueux.u-bordeaux.fr about a location
# https://www.iut.u-bordeaux-montaigne.fr about a school
# https://mmibordeaux.com about a program
# https://www.degrowthjournal.org about a journal
# hthttps://mica.u-bordeaux-montaigne.fr about a laboratory
module WebsitesLinkable
  extend ActiveSupport::Concern

  def has_administrators?
    raise NoMethodError, "You must implement the `has_administrators?` method in #{self.class.name}"
  end

  def has_researchers?
    raise NoMethodError, "You must implement the `has_researchers?` method in #{self.class.name}"
  end

  def has_teachers?
    raise NoMethodError, "You must implement the `has_teachers?` method in #{self.class.name}"
  end

  def has_education_schools?
    raise NoMethodError, "You must implement the `has_education_schools?` method in #{self.class.name}"
  end

  def has_education_programs?
    raise NoMethodError, "You must implement the `has_education_programs?` method in #{self.class.name}"
  end

  def has_education_diplomas?
    raise NoMethodError, "You must implement the `has_education_diplomas?` method in #{self.class.name}"
  end

  def has_research_journals?
    raise NoMethodError, "You must implement the `has_research_journals?` method in #{self.class.name}"
  end

  def has_research_laboratories?
    raise NoMethodError, "You must implement the `has_research_laboratories?` method in #{self.class.name}"
  end

  def has_research_papers?
    raise NoMethodError, "You must implement the `has_research_papers?` method in #{self.class.name}"
  end

  def has_research_volumes?
    raise NoMethodError, "You must implement the `has_research_volumes?` method in #{self.class.name}"
  end

  def has_administration_locations?
    raise NoMethodError, "You must implement the `has_administration_locations?` method in #{self.class.name}"
  end
end
