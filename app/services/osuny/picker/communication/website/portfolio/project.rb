class Osuny::Picker::Communication::Website::Portfolio::Project < Osuny::Picker

  def website
    context
  end

  def objects
    @objects ||= website.portfolio_projects
  end

  def categories
    @categories ||= website.portfolio_categories
  end

end