class Admin::Education::Programs::TeachersController < Admin::Education::Programs::ApplicationController
  load_and_authorize_resource :involvement,
                              class: University::Person::Involvement,
                              through: :program,
                              through_association: :university_person_involvements,
                              parent: false

  def destroy
    @involvement.destroy
    redirect_back fallback_location: admin_education_program_path(@program), notice: t('admin.successfully_quit_html', model: @involvement.to_s_in(current_language), target: @involvement.target.to_s_in(current_language))
  end

end