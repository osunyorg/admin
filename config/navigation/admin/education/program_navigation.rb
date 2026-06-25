SimpleNavigation::Configuration.run do |navigation|
  navigation.renderer = ::SimpleNavigation::Renderer::Links
  navigation.auto_highlight = true
  navigation.highlight_on_subpath = true
  navigation.selected_class = 'active'

  navigation.items do |primary|
    primary.item  :subnav_summary,
                  t('admin.subnav.summary'),
                  admin_education_program_path(id: @program, program_id: nil),
                  highlights_on: lambda {
                    controller_name == "programs" && action_name == "show"
                  } if can?(:read, @program)
    primary.item  :subnav_pedagogy,
                  t('education.program.parts.pedagogy.label'),
                  pedagogy_admin_education_program_path(id: @program, program_id: nil)
    primary.item  :subnav_admission,
                  t('education.program.parts.admission.label'),
                  admission_admin_education_program_path(id: @program, program_id: nil)
    primary.item  :subnav_certification,
                  t('education.program.parts.certification.label'),
                  certification_admin_education_program_path(id: @program, program_id: nil)
    primary.item  :subnav_cohorts,
                  Administration::Cohort.model_name.human(count: 2),
                  admin_education_program_cohorts_path(@program),
                  highlights_on: lambda {
                    controller_name == "cohorts" && action_name == "index"
                  } if @program.cohorts.any?
  end
end
