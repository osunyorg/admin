class Communication::File::Picker
  attr_reader :objects, :language, :params

  def initialize(objects, language, params)
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
      current_page: paginated_objects.current_page,
      limit_value: paginated_objects.limit_value,
      total_count: paginated_objects.total_count,
      total_pages: paginated_objects.total_pages,
      query_parameters: "&page=#{paginated_objects.current_page}"
    }
  end

  def paginated_objects
    @paginated_objects ||= objects.filter_by(params[:filters], language)
                                  .ordered(language)
                                  .page(params[:page])
                                  .per(2)
  end

  protected

  def search
    {
      term: term,
      query_parameters: "&filters[for_search_term]=#{term}"
    }
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