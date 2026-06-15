class DestroyUniversityJob < ApplicationJob
  queue_as :whales

  OBJECTS_NOT_PARANOID = [
      Search,
      Communication::Media::Context,
      Communication::Media::Localization,
      Communication::Media,
      Communication::Media::Category::Localization,
      Communication::Media::Category,
      Communication::Media::Collection::Localization,
      Communication::Media::Collection,
      Communication::Extranet::Document::Localization,
      Communication::Extranet::Document,
      Communication::Extranet::Document::Category::Localization,
      Communication::Extranet::Document::Category,
      Communication::Extranet::Document::Kind::Localization,
      Communication::Extranet::Document::Kind,
      Communication::Extranet::Post::Category::Localization,
      Communication::Extranet::Post::Category,
      Communication::Extranet::Post::Localization,
      Communication::Extranet::Post,
      Communication::Extranet::Connection,
      Communication::Extranet::Localization,
      Communication::Extranet,
      Education::Program::Category::Localization,
      Education::Program::Category,
      University::Organization::Category::Localization,
      University::Organization::Category,
      University::Person::Category::Localization,
      University::Person::Category,
      University::App,
      EmergencyMessage,
      Import
    ].freeze
  OBJECTS_PARANOID = [
      Administration::Location::Localization,
      Administration::Location,
      Education::AcademicYear::Localization,
      Education::AcademicYear,
      Education::Cohort::Localization,
      Education::Cohort,
      Education::Diploma::Localization,
      Education::Diploma,
      Education::Program::Localization,
      Education::Program,
      Education::School::Localization,
      Education::School,
      Research::Journal::Paper::Kind::Localization,
      Research::Journal::Paper::Kind,
      Research::Journal::Volume::Localization,
      Research::Journal::Volume,
      Research::Journal::Paper::Localization,
      Research::Journal::Paper,
      Research::Journal::Localization,
      Research::Journal,
      Research::Laboratory::Axis::Localization,
      Research::Laboratory::Axis,
      Research::Thesis::Localization,
      Research::Thesis,
      Research::Laboratory::Localization,
      Research::Laboratory,
      University::Organization::Localization,
      University::Organization,
      University::Person::Experience::Localization,
      University::Person::Experience,
      University::Person::Involvement::Localization,
      University::Person::Involvement,
      University::Role::Localization,
      University::Role,
      University::Person::Localization,
      University::Person,
      Communication::Block # We finish by blocks to avoid foreign key issues
    ].freeze

  def perform(university)
    # Destroy all the websites of the university
    university.websites.each do |website|
      Communication::Website::DestroyWebsiteJob.perform_now(website)
    end
    OBJECTS_NOT_PARANOID.each do |klass|
      klass.where(university_id: university.id).destroy_all
    end

    # Custom logic for users as we need to prevent server admin from being destroyed of all universities
    User.where(university_id: university.id).find_each do |user|
      user.skip_server_admin_sync = true if user.server_admin?
      user.destroy
    end

    OBJECTS_PARANOID.each do |klass|
      klass.with_deleted
           .where(university: university.id)
           .find_each(&:really_destroy!)
    end
    university.destroy
  end

end
