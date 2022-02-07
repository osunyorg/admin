class Admin::Communication::Website::StructureController < Admin::Communication::Website::ApplicationController
  before_action :get_structure, :ensure_abilities

  def edit
    breadcrumb
    add_breadcrumb Communication::Website::Structure.model_name.human
    render 'admin/communication/website/structures/edit'
  end

  def update
    if @structure.update_and_sync(structure_params)
      redirect_to admin_communication_website_path(@website), notice: t('admin.successfully_updated_html', model: Communication::Website::Structure.model_name.human)
    else
      breadcrumb
      add_breadcrumb Communication::Website::Structure.model_name.human
      render :edit, status: :unprocessable_entity
    end
  end

  protected

  def get_structure
    @structure = @website.structure
  end

  def ensure_abilities
    authorize! :update, @structure
  end

  def structure_params
    params.require(:communication_website_structure)
          .permit(
            :home_title,
            :communication_posts_title, :communication_posts_description, :communication_posts_path,
            :education_programs_title, :education_programs_description, :education_programs_path,
            :research_articles_title, :research_articles_description, :research_articles_path,
            :research_volumes_title, :research_volumes_description, :research_volumes_path,
            :persons_title, :persons_description, :persons_path,
            :administrators_title, :administrators_description, :administrators_path,
            :authors_title, :authors_description, :authors_path,
            :researchers_title, :researchers_description, :researchers_path,
            :teachers_title, :teachers_description, :teachers_path
          )
  end
end
