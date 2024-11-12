module FacetedSearch
  class Facets::Text < Facets::Default
    include ActiveRecord::Sanitization

    def placeholder
      @options[:placeholder]
    end

    def add_scope(scope)
      return scope if params.blank?
      language = facets.language
      search_term = self.class.sanitize_sql_like(params)
      scope.for_search_term(search_term, language)
    end
  end
end