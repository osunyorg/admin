class Communication::Extranet::Document::Facets < FacetedSearch::Facets
  def initialize(params, extranet)
    super(params)
    @model = extranet.documents
    filter_with_text :name
    # filter_with_list :category, {
    #   source: extranet.document_categories
    # }
    # filter_with_list :kind, {
    #   source: extranet.document_kinds
    # }
  end
end