class Osuny::Picker::Education::Program < Osuny::Picker

  def objects
    @objects ||= university.education_programs
  end

  def categories
    @categories ||= university.education_program_categories
  end

end