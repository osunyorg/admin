class Education::Cohort::Facets < FacetedSearch::Facets
  def initialize(params, options)
    super params

    @model = options[:model]
    @about = options[:about]

    filter_with_list :academic_years, {
      source: @about.academic_years.ordered,
      title: Education::AcademicYear.model_name.human(count: 2)
    }

    filter_with_checkboxes :programs, {
      source: @about.programs.ordered,
      title: Education::Program.model_name.human(count: 2)
    } unless @about.is_a? Education::Program
  end
end
