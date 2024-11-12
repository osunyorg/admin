class University::Organization::Facets < FacetedSearch::Facets
  attr_reader :language

  def initialize(params, options)
    super params

    @model = options[:model]
    @about = options[:about]
    @language = options[:language]
    @categories = options[:categories]

    filter_with_text :name, {
      title: University::Organization::Localization.human_attribute_name('name')
    }

    @categories.taxonomies.each do |taxonomy|
      taxonomy_l10n = taxonomy.localization_for(@language)
      next if taxonomy_l10n.nil?
      add_facet FacetedSearch::Facets::Taxonomy, taxonomy_l10n.slug, {
        l10n: taxonomy_l10n
      }
    end
  end
end
