module FacetedSearch
  class Facets::Category::Taxonomy < Facets::List
    attr_reader :l10n, :taxonomy, :language, :university

    def initialize(name, params, facets, options)
      @name = name
      @params = params
      @facets = facets
      @options = options
      @l10n = options[:l10n]
      @taxonomy = @l10n.about
      @language = @l10n.language
      @university = @taxonomy.university
    end

    def title
      l10n.to_s
    end

    def values
      descendants.ordered(language)
    end

    def add_scope(scope)
      return scope if params_array.blank?
      scope.joins(:categories).where(categories: { id: params_array })
    end

    protected

    def descendants
      categories_class.where(
        university: university,
        id: taxonomy.descendants.pluck(:id)
      )
    end
    
    def categories_class
      taxonomy.class
    end
  end
end