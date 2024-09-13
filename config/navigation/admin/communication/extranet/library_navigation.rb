SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_nav_documents,
                  Communication::Extranet::Document.model_name.human(count: 2),
                  admin_communication_extranet_documents_path(extranet_id: @extranet.id),
                  highlights_on: lambda { 
                    controller_name == "documents" && action_name == "index" 
                  }
    primary.item  :feature_nav_categories,
                  Communication::Extranet::Document::Category.model_name.human(count: 2),
                  admin_communication_extranet_document_categories_path(extranet_id: @extranet.id)
    primary.item  :feature_nav_kinds,
                  Communication::Extranet::Document::Kind.model_name.human(count: 2),
                  admin_communication_extranet_document_kinds_path(extranet_id: @extranet.id)
  end
end
