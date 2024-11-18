class Education::Cohort::Facets < FacetedSearch::Facets
  def initialize(params, options)
    super params

    @model = options[:model]
    @about = options[:about]
    @language = options[:language]

    filter_with_list :academic_year_id, {
      source: @about.academic_years.ordered,
      title: Education::AcademicYear.model_name.human(count: 2)
    }

    filter_with_checkboxes :program_id, {
      source: @about.programs.ordered(@language),
      title: Education::Program.model_name.human(count: 2),
      display_method: Proc.new { |program| program.to_s_in(@language) }
    } unless @about.is_a? Education::Program
  end
end
