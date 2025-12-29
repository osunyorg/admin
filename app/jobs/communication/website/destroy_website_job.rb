class Communication::Website::DestroyWebsiteJob < ApplicationJob
  def perform(website)
    [
      Communication::Website::Page::Localization,
      Communication::Website::Page,
    ].each do |klass|
      klass.with_deleted
          .where(communication_website_id: website)
          .find_each(&:really_destroy!)
    end
    website.destroy
  end
end