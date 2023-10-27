class Admin::Communication::Websites::PermalinksController < Admin::Communication::Websites::ApplicationController

  def create
    @path = params['communication_website_permalink']['path']
    @about = PolymorphicObjectFinder.find(params, :about)
    @permalink = @about.add_redirection(@path)
  end
end