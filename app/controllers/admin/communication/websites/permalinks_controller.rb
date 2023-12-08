class Admin::Communication::Websites::PermalinksController < Admin::Communication::Websites::ApplicationController

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
end