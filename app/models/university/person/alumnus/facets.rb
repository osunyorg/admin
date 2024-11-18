class University::Person::Alumnus::Facets < FacetedSearch::Facets
  def initialize(params, options)
    super params

    @model = options[:model]
    @about = options[:about]
    @language = options[:language]

    filter_with_text :name, {
      title: University::Person::Localization.human_attribute_name('name')
    }

    filter_with_list :diploma_years, {
      source: @about.academic_years.ordered,
      title: Education::AcademicYear.model_name.human(count: 2),
      habtm: true
    }

    filter_with_checkboxes :diploma_programs, {
      source: @about.programs.ordered(@language),
      title: Education::Program.model_name.human(count: 2),
      display_method: Proc.new { |program| program.to_s_in(@language) },
      habtm: true
    } unless @about.is_a? Education::Program
  end
end
