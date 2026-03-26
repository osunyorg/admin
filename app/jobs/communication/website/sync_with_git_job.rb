class Communication::Website::SyncWithGitJob < Communication::Website::BaseJob
  def execute
    batch_slice_size = options.fetch(:batch_slice_size, nil)
    website.sync_with_git_safely(batch_slice_size: batch_slice_size)
  end
end
