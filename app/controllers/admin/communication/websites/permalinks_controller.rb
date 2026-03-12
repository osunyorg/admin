class Admin::Communication::Websites::PermalinksController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource class: Communication::Website::Permalink,
                              through: :website

  def new
    breadcrumb
    add_breadcrumb(t('create'))
  end

  def edit
    breadcrumb
    add_breadcrumb(t('edit'))
  end

  def create
    creating_from_about? ? create_from_about : create_from_form
  end

  def update
    if @permalink.update(permalink_params)
      redirect_to redirects_admin_communication_website_path(id: params[:website_id]),
                  notice: t('admin.successfully_updated_html', model: @permalink.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @permalink.destroy
    respond_to do |format|
      format.js { }
      format.html {
        redirect_to redirects_admin_communication_website_path(id: params[:website_id], website_id: nil),
                    notice: t('admin.successfully_duplicated_html', model: @permalink.to_s)
      }
    end
  end

  protected

  def creating_from_about?
    params.has_key?('about_id') &&
    params.has_key?('about_type')
  end

  def create_from_about
    @about = PolymorphicObjectFinder.find(
      params,
      key: :about,
      university: current_university,
      mandatory_module: Permalinkable
    )
    @path = params['communication_website_permalink']['path']
    @permalink = @about.add_redirection(@path)
  end

  def create_from_form
    @permalink.is_current = false
    if @permalink.save
      redirect_to redirects_admin_communication_website_path(id: params[:website_id]),
            notice: t('admin.successfully_created_html', model: @permalink.to_s)
    else
      breadcrumb
      add_breadcrumb t('edit')
      render :edit, status: :unprocessable_content
    end
  end

  def breadcrumb
    super
    add_breadcrumb t('admin.subnav.settings'), edit_admin_communication_website_path(@website, website_id: nil)
    add_breadcrumb t('admin.communication.website.redirects.label'), redirects_admin_communication_website_path(@website, website_id: nil)
  end

  def permalink_params
    params.require(:communication_website_permalink)
          .permit(
            :path,
            :target_url
          )
          .merge(
            university_id: current_university.id,
            website_id: @website.id
          )
  end

end