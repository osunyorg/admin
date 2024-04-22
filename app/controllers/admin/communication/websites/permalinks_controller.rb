class Admin::Communication::Websites::PermalinksController < Admin::Communication::Websites::ApplicationController
  load_and_authorize_resource class: Communication::Website::Permalink, through: :website, only: :destroy

  def create
    @path = params['communication_website_permalink']['path']
    @about = PolymorphicObjectFinder.find(
      params,
      key: :about,
      university: current_university,
      only: Communication::Website::Permalink.permitted_about_types
    )
    @permalink = @about.add_redirection(@path)
  end

  def destroy
    @permalink.about.remove_redirection(@permalink)
  end
end