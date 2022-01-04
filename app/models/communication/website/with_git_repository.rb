module Communication::Website::WithGitRepository
  extend ActiveSupport::Concern

  included do
    has_many :git_files,
             class_name: 'Communication::Website::GitFile',
             dependent: :destroy
  end

  def git_repository
    @git_repository ||= Git::Repository.new self
  end
end
