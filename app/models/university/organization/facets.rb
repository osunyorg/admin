class University::Organization::Facets < FacetedSearch::Facets
  def initialize(params, options)
    super params

    @model = options[:model]
    @about = options[:about]

    filter_with_text :name, {
      title: University::Organization.human_attribute_name('name')
    }

  end
end
