class Osuny::Picker::University::Organization < Osuny::Picker

  def objects
    @objects ||= university.university_organizations
  end

  def categories
    @categories ||= university.university_organization_categories
  end

end