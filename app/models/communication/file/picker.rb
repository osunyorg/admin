class Communication::File::Picker
  attr_reader :objects, :language, :params

  def initialize(objects:, language:, params:)
    @objects = objects
    @language = language
    @params = params
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

  def filters
    [
      {
        id: 'categories',
        name: 'Catégories',
        values: [
          { id: 'cat-1', name: 'Catégorie 1', selected: false }
        ]
      }
    ]
  end
  
  def sorts
    [
      {
        id: 'date-desc',
        name: 'Les plus récents d\'abord',
        selected: true
      },
      {
        id: 'date-asc',
        name: 'Les plus anciens d\'abord',
        selected: false
      }
    ]
  end
end