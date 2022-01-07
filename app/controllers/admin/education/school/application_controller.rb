class Admin::Education::School::ApplicationController < Admin::Education::ApplicationController
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
    return {} unless params.has_key? :school_id
    {
      school_id: params[:school_id]
    }
  end
end
