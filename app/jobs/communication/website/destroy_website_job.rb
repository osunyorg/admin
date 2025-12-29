class Communication::Website::DestroyWebsiteJob < ApplicationJob
  queue_as :whales

  attr_reader :website

  CATEGORIES = [
      Communication::Website::Agenda::Category::Localization,
      Communication::Website::Agenda::Category,
      Communication::Website::Jobboard::Category::Localization,
      Communication::Website::Jobboard::Category,
      Communication::Website::Page::Category::Localization,
      Communication::Website::Page::Category,
      Communication::Website::Portfolio::Category::Localization,
      Communication::Website::Portfolio::Category,
      Communication::Website::Post::Category::Localization,
      Communication::Website::Post::Category,
    ]
  OBJECTS = [
      Communication::Website::Agenda::Event::Localization,
      Communication::Website::Agenda::Event,
      Communication::Website::Agenda::Exhibition::Localization,
      Communication::Website::Agenda::Exhibition,
      Communication::Website::Alert::Localization,
      Communication::Website::Alert,
      Communication::Website::Jobboard::Job::Localization,
      Communication::Website::Jobboard::Job,
      Communication::Website::Page::Localization,
      Communication::Website::Page,
      Communication::Website::Portfolio::Project::Localization,
      Communication::Website::Portfolio::Project,
      Communication::Website::Post::Localization,
      Communication::Website::Post,
    ]

  def perform(website)
    @website = website
    Search.remove_data_for_website(website)
    destroy_categories
    destroy_objects
    website.deuxfleurs_destroy_bucket
    website.destroy
  end
  
  protected

  def destroy_categories
    CATEGORIES.each do |klass|
      klass.where(communication_website_id: website).destroy_all
    end
  end

  def destroy_objects
    OBJECTS.each do |klass|
      klass.with_deleted
           .where(communication_website_id: website)
           .find_each(&:really_destroy!)
    end
  end
end