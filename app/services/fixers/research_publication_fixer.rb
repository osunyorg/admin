class Fixers::ResearchPublicationFixer
  def self.run
    # Connections

    connection_ids_to_destroy = []
    connection_ids_to_update = []

    Communication::Website::Connection.where(indirect_object_type: "Research::Hal::Publication").find_each do |connection|
      already_migrated_connection = Communication::Website::Connection.find_by(
        direct_source_type: connection.direct_source_type,
        direct_source_id: connection.direct_source_id,
        indirect_object_type: "Research::Publication",
        indirect_object_id: connection.indirect_object_id,
        university_id: connection.university_id,
        website_id: connection.website_id
      )
      if already_migrated_connection.present?
        connection_ids_to_destroy << connection.id
      else
        connection_ids_to_update << connection.id
      end
    end

    Communication::Website::Connection.where(id: connection_ids_to_destroy).destroy_all
    Communication::Website::Connection.where(id: connection_ids_to_update).update_all(indirect_object_type: "Research::Publication")

    # Git Files

    git_file_ids_to_destroy = []
    git_file_ids_to_update = []

    Communication::Website::GitFile.where(about_type: "Research::Hal::Publication").find_each do |git_file|
      already_migrated_git_file = Communication::Website::GitFile.find_by(
        about_type: "Research::Publication",
        about_id: git_file.about_id,
        website_id: git_file.website_id
      )
      if already_migrated_git_file.present?
        git_file_ids_to_destroy << git_file.id
      else
        git_file_ids_to_update << git_file.id
      end
    end

    Communication::Website::GitFile.where(id: git_file_ids_to_destroy).destroy_all
    Communication::Website::GitFile.where(id: git_file_ids_to_update).update_all(about_type: "Research::Publication")

    # Permalinks

    ## Old permalinks

    Communication::Website::Permalink.where(about_type: "Research::Hal::Publication", is_current: false).update_all(about_type: "Research::Publication")

    permalink_ids_to_destroy = []
    permalink_ids_to_update = []

    ## Current permalinks

    Communication::Website::Permalink.where(about_type: "Research::Hal::Publication", is_current: true).find_each do |permalink|
      already_migrated_permalink = Communication::Website::GitFile.find_by(
        about_type: "Research::Publication",
        about_id: permalink.about_id,
        website_id: permalink.website_id,
        university_id: permalink.university_id,
        is_current: true
      )
      if already_migrated_permalink.present?
        permalink_ids_to_destroy << permalink.id
      else
        permalink_ids_to_update << permalink.id
      end
    end

    Communication::Website::Permalink.where(id: permalink_ids_to_destroy).destroy_all
    Communication::Website::Permalink.where(id: permalink_ids_to_update).update_all(about_type: "Research::Publication")
  end
end