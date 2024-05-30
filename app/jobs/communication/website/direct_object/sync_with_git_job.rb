class Communication::Website::DirectObject::SyncWithGitJob < Communication::Website::BaseJob
  def execute
    direct_object = options.fetch(:direct_object)
    direct_object.sync_with_git_safely if direct_object.present?
  end
end