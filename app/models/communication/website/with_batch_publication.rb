module Communication::Website::WithBatchPublication
  extend ActiveSupport::Concern

  included do
    def force_publish!
      commit_files_in_batch github_files,
                            "[Website] Batch update from import"
    end
    handle_asynchronously :force_publish!, queue: 'default'

    def publish_members!
      commit_files_in_batch github_files.where(about_type: "Administration::Member"),
                            "[Member] Batch update from import"
    end

    def publish_categories!
      commit_files_in_batch github_files.where(about_type: "Communication::Website::Category"),
                            "[Category] Batch update from import"
    end

    def publish_pages!
      commit_files_in_batch github_files.where(about_type: "Communication::Website::Page"),
                            "[Page] Batch update from import"
    end

    def publish_posts!
      commit_files_in_batch github_files.where(about_type: "Communication::Website::Post"),
                            "[Post] Batch update from import"
    end

    def publish_menus!
      commit_files_in_batch github_files.where(about_type: "Communication::Website::Menu"),
                            "[Menu] Batch update from import"
    end

    def publish_school!
      commit_files_in_batch github_files.where(about_type: [
                              "Education::School",
                              "Education::Program",
                              "Administration::Member"
                            ]),
                            "[Education School/Program/Teacher] Batch update from import"
    end

    def publish_journal!
      commit_files_in_batch github_files.where(about_type: [
                              "Research::Journal",
                              "Research::Journal::Article",
                              "Research::Journal::Volume",
                              "Administration::Member"
                            ]),
                            "[Research Journal/Article/Volume/Researcher] Batch update from import"
    end

    protected

    def commit_files_in_batch(files, commit_message)
      files.find_each { |file| file.add_to_batch(github) }
      github.commit_batch commit_message
    end
  end

end
