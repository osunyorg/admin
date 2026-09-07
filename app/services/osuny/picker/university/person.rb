class Osuny::Picker::University::Person < Osuny::Picker

  def objects
    @objects ||= university.university_people
  end

  def categories
    @categories ||= university.university_person_categories
  end

end