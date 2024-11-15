module FacetedSearch
  class Facets::Text < Facets::Default
    include ActiveRecord::Sanitization

    def placeholder
      @options[:placeholder]
    end

    def add_scope(scope)
      return scope if params.blank?
      language = facets.language
      scope.for_search_term(params, language)
    end
  end
end