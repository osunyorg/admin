class Extranet::ExperiencesController < Extranet::ApplicationController
  load_and_authorize_resource class: University::Person::Experience,
                              through: :current_user,
                              through_association: :experiences
  def new
    breadcrumb
  end
  
  def edit
    breadcrumb
  end

  def create
    @experience.university = current_university
    if @experience.save
      redirect_to account_path, notice: 'Ok'
    else
      breadcrumb
      render :new
    end
  end

  def update
    if @experience.update experience_params
      redirect_to account_path, notice: 'Ok'
    else
      breadcrumb
      render :edit
    end
  end

  protected

  def experience_params
    params.require(:university_person_experience)
          .permit(:description, :from_year, :to_year, :organization_id)
  end

  def breadcrumb
    super
    add_breadcrumb t('extranet.account.my'), account_path
    add_breadcrumb @experience
  end
end