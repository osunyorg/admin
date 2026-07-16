class Communication::File::Picker
  attr_reader :objects, :language, :params

  def initialize(objects, language, params)
    @objects = objects
    @language = language
    @params = params.to_unsafe_hash
  end

  def parameters
    {
      search: search,
      filters: filters,
      sorts: sorts,
      pagination: pagination
    }
  end

  def paginated_objects
    @paginated_objects ||= objects.ordered(language).page(params[:page])
  end

  protected

  def search
    ''
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
        name: 'Trier du plus récent au plus ancien',
        selected: true
      },
      {
        id: 'date-asc',
        name: 'Trier du plus ancien au plus récent',
        selected: false
      }
    ]
  end

  def pagination
    {
      current_page: paginated_objects.current_page,
      limit_value:  paginated_objects.limit_value,
      total_count:  paginated_objects.total_count,
      total_pages:  paginated_objects.total_pages
    }
  end

end