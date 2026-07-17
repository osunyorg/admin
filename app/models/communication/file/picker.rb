class Communication::File::Picker
  attr_reader :objects, :language, :params

  def initialize(objects, language, params)
    @objects = objects
    @language = language
    @params = params.to_unsafe_hash
  end

  def parameters
    {
      term: term,
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
    @paginated_objects ||= objects.ordered(language)
                                  .page(params[:page])
                                  .per(2)
  end

  protected

  def term
    params[:term]
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