SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Osuny::FeatureNav
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true

  navigation.items do |primary|
    primary.item  :feature_nav_papers,
                  Research::Journal::Paper.model_name.human(count: 2),
                  admin_research_journal_papers_path(journal_id: @journal),
                  highlights_on: lambda {
                    controller_name == "papers" && action_name == "index"
                  }
    primary.item  :feature_nav_kinds,
                  Research::Journal::Paper::Kind.model_name.human(count: 2),
                  admin_research_journal_kinds_path(journal_id: @journal)
  end
end
