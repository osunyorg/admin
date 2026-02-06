class Communication::Website::DestroyWebsiteJob < ApplicationJob
  queue_as :whales

  OBJECTS_NOT_PARANOID = [
      Communication::Website::Agenda::Category::Localization,
      Communication::Website::Agenda::Category,
      Communication::Website::Agenda::Event::Day,
      Communication::Website::Agenda::Period::Day,
      Communication::Website::Agenda::Period::Day::Localization,
      Communication::Website::Agenda::Period::Month,
      Communication::Website::Agenda::Period::Month::Localization,
      Communication::Website::Agenda::Period::Year,
      Communication::Website::Agenda::Period::Day::Localization,
      Communication::Website::Jobboard::Category::Localization,
      Communication::Website::Jobboard::Category,
      Communication::Website::Page::Category::Localization,
      Communication::Website::Page::Category,
      Communication::Website::Portfolio::Category::Localization,
      Communication::Website::Portfolio::Category,
      Communication::Website::Post::Category::Localization,
      Communication::Website::Post::Category,
    ].freeze
  OBJECTS_PARANOID = [
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
      Communication::Block # We finish by blocks to avoid foreign key issues
    ].freeze

  def perform(website)
    # Empty Git info to prevent content deletion
    website.update_columns(
      access_token: nil,
      repository: nil,
    )
    Search.remove_data_for_website(website)
    OBJECTS_NOT_PARANOID.each do |klass|
      klass.where(communication_website_id: website.id).destroy_all
    end
    OBJECTS_PARANOID.each do |klass|
      klass.with_deleted
           .where(communication_website_id: website.id)
           .find_each(&:really_destroy!)
    end
    website.deuxfleurs_destroy_bucket
    website.destroy
  end

end
