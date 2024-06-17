SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Links
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item  :subnav_summary,
                  t('admin.subnav.summary'), 
                  admin_education_root_path, 
                  highlights_on: lambda { 
                    controller_name == "dashboard" && action_name == "index" 
                  }
    primary.item  :subnav_teachers,
                  University::Person::Teacher.model_name.human(count: 2),
                  admin_education_teachers_path
    primary.item  :subnav_schools,
                  Education::School.model_name.human(count: 2),
                  admin_education_schools_path
    primary.item  :subnav_diplomas,
                  Education::Diploma.model_name.human(count: 2),
                  admin_education_diplomas_path
    primary.item  :subnav_programs,
                  Education::Program.model_name.human(count: 2),
                  admin_education_programs_path
  end
end
