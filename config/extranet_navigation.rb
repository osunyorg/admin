SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::BootstrapRenderer
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'
  navigation.items do |primary|
    primary.item      :posts,
                      Communication::Extranet.human_attribute_name(:feature_posts),
                      posts_root_path if current_extranet.feature_posts?

    primary.item      :files,
                      Communication::Extranet.human_attribute_name(:feature_files),
                      files_root_path if current_extranet.feature_files?

    primary.item      :contacts, 
                      Communication::Extranet.human_attribute_name(:feature_contacts) do |secondary|
      secondary.item  :person,
                      University::Person.model_name.human(count: 2),
                      contacts_university_persons_path
      secondary.item  :organizations,
                      University::Organization.model_name.human(count: 2),
                      contacts_university_organizations_path
    end if current_extranet.feature_contacts?

    primary.item      :alumni, 
                      University::Person::Alumnus.model_name.human(count: 2) do |secondary|
      secondary.item  :person,
                      University::Person.model_name.human(count: 2),
                      alumni_university_persons_path
      secondary.item  :years,
                      Education::AcademicYear.model_name.human(count: 2),
                      alumni_education_academic_years_path if current_extranet.should_show_years?
      secondary.item  :cohorts,
                      Education::Cohort.model_name.human(count: 2),
                      alumni_education_cohorts_path
      secondary.item  :organizations,
                      University::Organization.model_name.human(count: 2),
                      alumni_university_organizations_path
    end if current_extranet.feature_alumni?
  end
end