class Osuny::Picker

  attr_reader :university, :language, :params, :context

  # context peut être un website, un extranet, un journal...
  def initialize(university:, language:, params:, context: nil)
    @university = university
    @language = language
    @params = params
    @context = context
    sorts
  end
  
  def objects
    raise NoMethodError, 'You must implement this method'
  end

  def categories
    nil
  end

  def parameters
    {
      search: search,
      filters: filters,
      sort: sort,
    }
  end

  def pagination
    {
      current_page: current_page,
      limit_value: results.limit_value,
      total_count: results.total_count,
      total_pages: results.total_pages,
      query_parameters: "&page=#{current_page}"
    }
  end

  # Si on était sur la page 5, qu'on a reserré la recherche et qu'il n'y a plus de page 5, on revient sur la page 1
  def results
    @results ||= objects_paginated.any? ? objects_paginated : objects_on_first_page
  end

  protected

  # Actions successives 
  # 1. filter
  # 2. sort
  # 3. paginate (avec gestion du retour page 1)

  def objects_filtered
    @objects_filtered ||= objects.filter_by(params[:filters], language)
  end

  def objects_sorted
    @objects_sorted ||= objects_filtered.autosort(current_sort, language)
  end

  def objects_paginated
    @objects_paginated ||= objects_sorted.page(params[:page])
  end

  def objects_on_first_page
    @objects_on_first_page ||= objects_sorted.page(1)
  end

  def search
    {
      term: term,
      query_parameters: "&filters[for_search_term]=#{term}"
    }
  end

  def current_page
    [results.current_page, results.total_pages].min
  end

  def term
    params.dig(:filters, :for_search_term).to_s
  end

  # [
  #   {
  #     name: 'Catégories',
  #     values: [
  #       {
  #         id: 'cat-1',
  #         name: 'Catégorie 1',
  #         selected: false,
  #         query_parameters: '&filters[for_category][]=d05ab9f9-a8fb-42e3-8aca-8fe73fa08913' }
  #     ]
  #   }
  # ]
  def filters
    filters = []
    return filters if categories.nil?
    categories.taxonomies.ordered(language).each do |taxonomy|
      filters << {
        name: taxonomy.to_s_in(language),
        values: transform_categories_to_values(taxonomy.children)
      }
    end
    if categories.free.any?
      filters << {
        name: I18n.t('category.title'),
        values: transform_categories_to_values(categories.free)
      }
    end
    filters
  end

  def transform_categories_to_values(categories)
    categories.ordered(language).map do |category|
      data = {
        id: category.id,
        name: category.to_s_in(language),
        selected: category.id.in?(params.to_s),
        query_parameters: "&filters[for_category][]=#{category.id}"
      }
      data[:values] = transform_categories_to_values(category.children) if category.children.any?
      data
    end
  end

  def sorts
    # Can be overridden to add sorts
  end

  def sort_add(name, key)
    sort[:values] <<  {
      id: key,
      name: name,
      query_parameters: "&sort=#{key}"
    }
    sort[:current] = key if sort[:current].blank?
  end
  
  def sort
    @sort ||= {
      current: params.dig(:sort),
      values: []
    }
  end

  def current_sort
    params.dig(:sort) || sort[:current]
  end
end