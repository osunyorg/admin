class Extranet::ExperiencesController < Extranet::ApplicationController
  def new
    @experience = current_user.experiences.new
    breadcrumb
  end

  def edit
    @experience = current_user.experiences.find(params[:id])
    breadcrumb
  end

  def create
    @experience = current_user.experiences.new(experience_params)
    @experience.university = current_university
    if @experience.save
      redirect_to account_path, notice: 'Ok'
    else
      breadcrumb
      render :new
    end
  end

  def update
    @experience = current_user.experiences.find(params[:id])
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