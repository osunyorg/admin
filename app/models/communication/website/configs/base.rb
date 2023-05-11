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

  def dependencies
    []
  end

  def references
    []
  end

end