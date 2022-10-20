class Admin::Communication::ExtranetsController < Admin::Communication::ApplicationController
  load_and_authorize_resource class: Communication::Extranet,
                              through: :current_university,
                              through_association: :communication_extranets

  has_scope :for_search_term
  has_scope :for_about_type

  def index
    @extranets = apply_scopes(@extranets).ordered.page(params[:page])
    breadcrumb
  end

  def show
    @about = @extranet.about
    @alumni = @extranet.alumni
    @cohorts = @extranet.cohorts
    @years = @extranet.years
    @organizations = @extranet.organizations
    breadcrumb
  end

  def new
    breadcrumb
  end

  def edit
    breadcrumb
    add_breadcrumb t('edit')
  end

  def create
    @extranet.university = current_university
    if @extranet.save
      redirect_to [:admin, @extranet], notice: t('admin.successfully_created_html', model: @extranet.to_s)
    else
      breadcrumb
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @extranet.update(extranet_params)
      redirect_to [:admin, @extranet], notice: t('admin.successfully_updated_html', model: @extranet.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @extranet.destroy
    redirect_to admin_communication_websites_url, notice: t('admin.successfully_destroyed_html', model: @extranet.to_s)
  end

  protected

  def breadcrumb
    super
    add_breadcrumb Communication::Extranet.model_name.human(count: 2), admin_communication_extranets_path
    breadcrumb_for @extranet
  end

  def extranet_params
    params.require(:communication_extranet)
          .permit(:name, :domain, :about_type, :about_id,
            :registration_contact, :logo, :logo_delete,
            :has_sso, :sso_inherit_from_university, :sso_target_url, :sso_cert, :sso_name_identifier_format, :sso_mapping
          )
  end
end
