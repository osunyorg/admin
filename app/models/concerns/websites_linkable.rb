# Means there might be a website about this object
# https://iut-perigueux.u-bordeaux.fr about a location
# https://www.iut.u-bordeaux-montaigne.fr about a school
# https://mmibordeaux.com about a program
# https://www.degrowthjournal.org about a journal
# hthttps://mica.u-bordeaux-montaigne.fr about a laboratory
module WebsitesLinkable
  extend ActiveSupport::Concern

  def has_administrators?
    raise NotImplementedError
  end

  def has_researchers?
    raise NotImplementedError
  end

  def has_teachers?
    raise NotImplementedError
  end

  def has_education_programs?
    raise NotImplementedError
  end

  def has_education_diplomas?
    raise NotImplementedError
  end

  def has_research_papers?
    raise NotImplementedError
  end

  def has_research_volumes?
    raise NotImplementedError
  end

  def has_administration_locations?
    raise NotImplementedError
  end
end
