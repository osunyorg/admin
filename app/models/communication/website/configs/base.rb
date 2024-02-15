class Communication::Website::Configs::Base < Communication::Website

  def self.polymorphic_name
    raise NotImplementedError
  end

  def git_path(website)
    raise NotImplementedError
  end

  def template_static
    raise NotImplementedError
  end

  ######
  # force dependencies & references to prevent multiple useless calls
  ######

  def dependencies
    []
  end

  def references
    []
  end

end
