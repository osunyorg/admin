class Communication::Extranet::Document::Facets < FacetedSearch::Facets
  def initialize(params, extranet, language)
    super(params)

    @model = extranet.documents
    @language = language

    filter_with_text :name, {
      title: Communication::Extranet::Document::Localization.human_attribute_name('name')
    }
    filter_with_list :category, {
      title: Communication::Extranet::Document::Category.model_name.human(count: 2),
      source: extranet.document_categories,
      habtm: false,
      display_method: Proc.new { |object| object.to_s_in(@language) }
    }
    filter_with_list :kind, {
      title: Communication::Extranet::Document::Kind.model_name.human(count: 2),
      source: extranet.document_kinds,
      habtm: false,
      display_method: Proc.new { |object| object.to_s_in(@language) }
    }
  end
end