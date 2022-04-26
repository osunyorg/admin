class University::Person::Alumnus::Facets < FacetedSearch::Facets
  def initialize(params, options)
    super params

    @model = options[:model]
    @about = options[:about]

    filter_with_text :name

    # TODO année de diplôme

    # TODO liste des formations (si about ≠ formation)
    # filter_with_list :program, {
    #   source: @about.programs,
    #   habtm: true
    # }
  end
end
