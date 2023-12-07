class Admin::Communication::Websites::PermalinksController < Admin::Communication::Websites::ApplicationController

  def create
    @path = params['communication_website_permalink']['path']
    model_names_with_permalinks = ApplicationRecord.descendants.select { |model| model.included_modules.include?(WithPermalink) }.map(&:name)
    @about = PolymorphicObjectFinder.find(params, :about, current_university, whitelist: model_names_with_permalinks)
    @permalink = @about.add_redirection(@path)
  end
end