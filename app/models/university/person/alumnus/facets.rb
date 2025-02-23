class University::Person::Alumnus::Facets < FacetedSearch::Facets
  attr_reader :language, :categories

  def initialize(params, options)
    super       params
    @model      = options[:model]
    @about      = options[:about]
    @language   = options[:language]
    @categories = options[:categories]
    add_name
    add_years
    add_programs
    add_taxonomies
  end

  protected

  def add_name
    filter_with_text :name, {
      title: University::Person::Localization.human_attribute_name('name')
    }
  end

  def add_years
    filter_with_list :diploma_years, {
      source: @about.academic_years.ordered,
      title: Education::AcademicYear.model_name.human(count: 2),
      habtm: true
    }
  end

  def add_programs
    return if @about.is_a? Education::Program
    filter_with_checkboxes :diploma_programs, {
      source: @about.programs.ordered(@language),
      title: Education::Program.model_name.human(count: 2),
      display_method: Proc.new { |program| program.to_s_in(@language) },
      habtm: true
    }
  end
  
  def add_taxonomies
    categories.taxonomies.each do |taxonomy|
      taxonomy_l10n = taxonomy.localization_for(language)
      next if taxonomy_l10n.nil?
      add_facet FacetedSearch::Facets::Taxonomy, taxonomy_l10n.slug, {
        l10n: taxonomy_l10n
      }
    end
  end
end
