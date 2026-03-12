class Admin::Communication::Websites::PermalinksController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource class: Communication::Website::Permalink, through: :website, only: :destroy

  def create
    @path = params['communication_website_permalink']['path']
    @about = PolymorphicObjectFinder.find(
      params,
      key: :about,
      university: current_university,
      mandatory_module: Permalinkable
    )
    @permalink = @about.add_redirection(@path)
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
end