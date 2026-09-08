class DestroyUniversityJob < ApplicationJob
  queue_as :whales

  def perform(university)
    # Destroy all the websites of the university
    university.websites.each do |website|
      Communication::Website::DestroyWebsiteJob.perform_now(website)
    end
    Osuny::Paranoid::OBJECTS_NOT_PARANOID.each do |klass|
      klass.where(university_id: university.id).destroy_all
    end

    # Custom logic for users as we need to prevent server admin from being destroyed of all universities
    User.where(university_id: university.id).find_each do |user|
      user.skip_server_admin_sync = true if user.server_admin?
      user.destroy
    end

    Osuny::Paranoid::OBJECTS_PARANOID.each do |klass|
      klass.with_deleted
           .where(university: university.id)
           .find_each(&:really_destroy!)
    end
    university.destroy
  end

end
