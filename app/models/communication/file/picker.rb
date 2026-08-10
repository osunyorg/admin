class Communication::File::Picker
  attr_reader :university, :language, :params

  def initialize(university:, language:, params:)
    @university = university
    @language = language
    @params = params
  end
  
  def objects
    @objects ||= university.communication_files
  end

  def categories
    @categories ||= university.communication_file_categories
  end

  def parameters
    {
      search: search,
      filters: filters,
      sorts: sorts,
      query_parameters: '',
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
    @objects_sorted ||= objects_filtered.ordered(language)
  end

  def objects_paginated
    @objects_paginated ||= objects_sorted.page(params[:page]).per(2)
  end

  def objects_on_first_page
    @objects_on_first_page ||= objects_sorted.page(1).per(2)
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
    [
      {
        id: 'date-desc',
        name: 'Les plus récents d\'abord',
        selected: true,
        query_parameters: "&sorts=date-desc"
      },
      {
        id: 'date-asc',
        name: 'Les plus anciens d\'abord',
        selected: false,
        query_parameters: "&sorts=date-asc"
      }
    ]
  end
end