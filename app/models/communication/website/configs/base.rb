class Communication::Website::Configs::Base < Communication::Website

  def self.polymorphic_name
    raise NoMethodError, "You must implement the `polymorphic_name` class method in #{self.class.name}"
  end

  def git_path(website)
    raise NoMethodError, "You must implement the `git_path` method in #{self.class.name}"
  end

  def can_have_git_file?
    true
  end

  def should_sync_to?(website)
    website.id == communication_website_id
  end

  def template_static
    raise NoMethodError, "You must implement the `template_static` method in #{self.class.name}"
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
