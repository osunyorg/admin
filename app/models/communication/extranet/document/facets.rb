class Communication::Extranet::Document::Facets < FacetedSearch::Facets
  def initialize(params, extranet)
    super(params)
    @model = extranet.documents.published
    filter_with_text :name, {
      title: Communication::Extranet::Document.human_attribute_name('name')
    }
    filter_with_list :category, {
      title: Communication::Extranet::Document::Category.model_name.human(count: 2),
      source: extranet.document_categories,
      habtm: false
    }
    filter_with_list :kind, {
      title: Communication::Extranet::Document::Kind.model_name.human(count: 2),
      source: extranet.document_kinds,
      habtm: false
    }
  end
end