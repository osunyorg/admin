class Extranet::PagesController < Extranet::ApplicationController
  skip_before_action :authenticate_user!, :authorize_extranet_access!
  before_action :load_extranet_localization, only: [:terms, :cookies_policy, :privacy_policy]

  def terms
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name('terms')
  end

  def cookies_policy
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name('cookies_policy')
  end

  def privacy_policy
    breadcrumb
    add_breadcrumb Communication::Extranet.human_attribute_name('privacy_policy')
  end

  def data
    @metrics = []
    if current_extranet.has_feature?(:alumni)
      alumni_count = current_extranet.alumni.count
      academic_years_count = current_extranet.academic_years.count
      cohorts_count = current_extranet.cohorts.count
      alumni_organizations_count = current_extranet.about.university_person_alumni_organizations.count
      @metrics.concat [
        { value: alumni_count, name: University::Person::Alumnus.model_name.human(count: alumni_count) },
        { value: academic_years_count, name: Administration::AcademicYear.model_name.human(count: academic_years_count) },
        { value: cohorts_count, name: Administration::Cohort.model_name.human(count: cohorts_count) },
        { value: alumni_organizations_count, name: University::Organization.model_name.human(count: alumni_organizations_count) }
      ]
    end
    if current_extranet.has_feature?(:contacts)
      connected_organizations_count = current_extranet.connected_organizations.count
      @metrics.concat [
        { value: connected_organizations_count, name: University::Organization.model_name.human(count: connected_organizations_count) }
      ]
    end
    if current_extranet.has_feature?(:alumni) || current_extranet.has_feature?(:contacts)
      users_count = current_extranet.users.count
      experiences_count = current_extranet.experiences.count
      @metrics.concat [
        { value: users_count, name: User.model_name.human(count: users_count) },
        { value: experiences_count, name: University::Person::Experience.model_name.human(count: experiences_count) },
      ]
    end
    breadcrumb
    add_breadcrumb t('extranet.data')
  end

  def load_extranet_localization
    @extranet_l10n = current_extranet.localization_for(current_language)
  end
end
