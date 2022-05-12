class Admin::Education::Programs::Roles::PeopleController < Admin::Education::Programs::ApplicationController
  load_and_authorize_resource :role, class: University::Role, through: :program, param: :role_id, through_association: :university_roles
  load_and_authorize_resource :involvement, class: University::Person::Involvement, through: :role, parent: false

  include Admin::Reorderable

  def destroy
    @involvement.destroy
    redirect_back fallback_location: admin_education_program_role_path(@role, { program_id: @program.id }), notice: t('admin.successfully_destroyed_html', model: @involvement.to_s)
  end

  protected

  def model
    University::Person::Involvement
  end
end
