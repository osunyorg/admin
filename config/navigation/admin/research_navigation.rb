SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Links
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item  :subnav_summary,
                  t('admin.subnav.summary'), 
                  admin_research_root_path, 
                  highlights_on: lambda { 
                    controller_name == "dashboard" && action_name == "index" 
                  }
    primary.item  :subnav_researchers,
                  University::Person::Researcher.model_name.human(count: 2),
                  admin_research_researchers_path
    primary.item  :subnav_laboratories,
                  Research::Laboratory.model_name.human(count: 2),
                  admin_research_laboratories_path
    primary.item  :subnav_theses,
                  Research::Thesis.model_name.human(count: 2),
                  admin_research_theses_path
    primary.item  :subnav_journals,
                  Research::Journal.model_name.human(count: 2),
                  admin_research_journals_path
    primary.item  :subnav_publications,
                  Research::Publication.model_name.human(count: 2),
                  admin_research_publications_path
  end
end
