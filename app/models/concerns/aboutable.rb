module Aboutable
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
end
