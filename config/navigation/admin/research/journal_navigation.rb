SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Links
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item  :subnav_summary,
                  t('admin.subnav.summary'), 
                  admin_research_journal_path(id: @journal, journal_id: nil),
                  highlights_on: lambda { 
                    controller_name == "journals" && action_name == "show" 
                  } if can?(:read, @journal)
    primary.item  :subnav_volumes,
                  Research::Journal::Volume.model_name.human(count: 2),
                  admin_research_journal_volumes_path(journal_id: @journal) if can?(:edit, @journal)
    primary.item  :subnav_papers,
                  Research::Journal::Paper.model_name.human(count: 2),
                  admin_research_journal_papers_path(journal_id: @journal) if can?(:edit, @journal)
    primary.item  :subnav_settings,
                  t('admin.subnav.settings'),
                  edit_admin_research_journal_path(id: @journal.id, journal_id: nil) if can?(:edit, @journal)
  end
end
