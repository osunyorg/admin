class Extranet::Account::ExperiencesController < Extranet::ApplicationController
  before_action :load_experience, only: [:edit, :update, :destroy]

  def new
    organization = current_university.organizations.find_by(id: params[:organization_id])
    @experience = current_user.experiences.new(organization: organization)
    @l10n = @experience.localizations.build(language: current_language)
    breadcrumb
    add_breadcrumb University::Person::Experience.human_attribute_name('new')
  end

  def edit
    @l10n = @experience.localization_for(current_language)
    breadcrumb
    add_breadcrumb @l10n
  end

  def create
    @experience = current_user.experiences.new(experience_params)
    if @experience.save
      redirect_to account_path,
                  notice: t('admin.successfully_created_html', model: @experience.class.model_name.human)
    else
      @l10n = @experience.localizations.first
      breadcrumb
      add_breadcrumb University::Person::Experience.human_attribute_name('new')
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @experience.update experience_params
      redirect_to account_path,
                  notice: t('admin.successfully_updated_html', model: @experience.class.model_name.human)
    else
      breadcrumb
      add_breadcrumb @l10n
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @experience.destroy
    redirect_to account_path,
                notice: t('admin.successfully_destroyed_html', model: @experience.class.model_name.human)
  end

  protected

  def load_experience
    @experience = current_user.experiences.find_by!(id: params[:id])
  end

  def experience_params
    params.require(:university_person_experience)
          .permit(
            :from_year, :to_year, :organization_id, :organization_name,
            localizations_attributes: [
              :id, :language_id,
              :description
            ]
          )
          .merge(
            university_id: current_university.id
          )
  end

  def breadcrumb
    super
    add_breadcrumb t('extranet.account.my'), account_path
  end
end
