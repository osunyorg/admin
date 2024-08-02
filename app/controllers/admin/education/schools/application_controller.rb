class Admin::Education::Schools::ApplicationController < Admin::Education::ApplicationController
  load_and_authorize_resource :school,
                              class: Education::School,
                              through: :current_university,
                              through_association: :education_schools

  protected

  def breadcrumb
    super
    add_breadcrumb @school, [:admin, @school]
  end

  def default_url_options
    options = super
    options[:school_id] = params[:school_id] if params.has_key? :school_id
    options
  end
end
