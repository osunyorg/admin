class Admin::Communication::Websites::PermalinksController < Admin::Communication::Websites::ApplicationController

  def create
    @about = PolymorphicObjectFinder.find(params, :about)
    @permalink = Communication::Website::Permalink.create(
      website: @website,
      about: @about,
      is_current: false,
      path: path
    )
  end

  protected

  def path
    unless @path
      @path = params['communication_website_permalink']['path']
      # Remove eventual host
      @path = URI(@path).path
      # Leading slash for absolute path
      @path = "/#{@path}" unless @path.start_with?('/')
      # Trailing slash for coherence
      @path = "#{@path}/" unless @path.end_with?('/')
    end
    @path
  end
end