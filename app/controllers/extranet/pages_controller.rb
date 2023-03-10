class Extranet::PagesController < Extranet::ApplicationController
  skip_before_action :authenticate_user!, :authorize_extranet_access!

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
      @metrics.concat [
        { value: current_extranet.alumni.count, name: University::Person::Alumnus.model_name.human(count: 2) },
        { value: current_extranet.academic_years.count, name: Education::AcademicYear.model_name.human(count: 2) },
        { value: current_extranet.cohorts.count, name: Education::Cohort.model_name.human(count: 2) }
      ]
    end
    if current_extranet.has_feature?(:alumni) || current_extranet.has_feature?(:contacts)
      @metrics.concat [
        { value: current_extranet.users.count, name: User.model_name.human(count: 2) },
        { value: current_extranet.experiences.count, name: University::Person::Experience.model_name.human(count: 2) },
        { value: current_extranet.organizations.count, name: University::Organization.model_name.human(count: 2) }
      ]
    end
    breadcrumb
    add_breadcrumb t('extranet.data')
  end
end
