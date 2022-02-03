class Admin::Education::School::Role::PeopleController < Admin::Education::School::ApplicationController
  load_and_authorize_resource :role, class: University::Role, through: :school, param: :role_id, through_association: :university_roles
  load_and_authorize_resource :involvement, class: University::Person::Involvement, through: :role, parent: false

  include Admin::Reorderable

  def destroy
    @involvement.destroy
    redirect_back fallback_location: admin_education_school_role_path(@role, { school_id: @school.id }), notice: t('admin.successfully_destroyed_html', model: @involvement.to_s)
  end

  protected

  def model
    University::Person::Involvement
  end
end
