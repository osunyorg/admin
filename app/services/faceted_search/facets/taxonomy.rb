module FacetedSearch
  class Facets::Taxonomy < Facets::List
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

    # INNER JOIN "university_organizations_categories" "university_organizations_categories_01234567-89ab-cdef-0123-4567890abcde"
    #   ON "university_organizations_categories_01234567-89ab-cdef-0123-4567890abcde"."organization_id" = "university_organizations"."id"
    # WHERE "university_organizations_categories_01234567-89ab-cdef-0123-4567890abcde"."category_id" IN (?)
    def add_scope(scope)
      return scope if params_array.blank?

      scope
        .joins("
          INNER JOIN \"#{association_join_table_name}\" \"#{association_join_table_name_alias}\"
            ON \"#{association_join_table_name_alias}\".\"#{join_table_foreign_key}\" = \"#{table_name}\".\"id\"
        ")
        .where(
          "\"#{association_join_table_name_alias}\".\"#{join_table_association_foreign_key}\" IN (?)",
          params_array
        )
    end

    protected

    def categories_class
      taxonomy.class
    end

    # university_organizations
    def table_name
      @facets.model.klass.table_name
    end

    def habtm_reflection
      @association_reflection ||= @facets.model.klass._reflections[:categories].parent_reflection
    end

    # organization_id
    def join_table_foreign_key
      @join_table_foreign_key ||= habtm_reflection.foreign_key
    end

    # category_id
    def join_table_association_foreign_key
      @join_table_association_foreign_key ||= habtm_reflection.association_foreign_key
    end

    # university_organizations_categories
    def association_join_table_name
      @association_join_table_name ||= habtm_reflection.join_table
    end

    # university_organizations_categories_01234567-89ab-cdef-0123-4567890abcde
    def association_join_table_name_alias
      @association_join_table_name_alias ||= "#{association_join_table_name}_#{taxonomy.id}"
    end

    def descendants
      categories_class.where(
        university: university,
        id: taxonomy.descendants.pluck(:id)
      )
    end
  end
end