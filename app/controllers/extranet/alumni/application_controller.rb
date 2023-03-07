class Extranet::Alumni::ApplicationController < Extranet::ApplicationController

  protected

  def breadcrumb
    super
    add_breadcrumb University::Person::Alumnus.model_name.human(count: 2), alumni_university_persons_path
  end
end