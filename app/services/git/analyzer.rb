class Git::Analyzer
  attr_accessor :git_file
  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def should_create?
    !should_destroy? &&
    !exists_on_git? &&
    (
      !synchronized_with_git? ||
      previous_path.nil? ||
      previous_sha.nil?
    )
  end

  def should_update?
    !should_destroy? &&
    (
      previous_path != path ||
      previous_sha != computed_sha
    )
  end

  def should_destroy?
    will_be_destroyed ||
    path.nil?
  end

  protected

  def path
    git_file.path
  end

  def sha
    git_file.sha
  end

  def computed_sha
    repository.computed_sha(git_file.to_s)
  end

  def will_be_destroyed
    git_file.will_be_destroyed
  end

  def previous_path
    git_file.previous_path
  end

  def previous_sha
    git_file.previous_sha
  end

  def exists_on_git?
    repository.git_sha(git_file.previous_path).present? ||  # The file exists where it was last time
    (
      git_file.previous_path.nil? &&                        # Never saved in the database
      repository.git_sha(git_file.path).present?            # but it exists in the git repo
    )
  end

  def synchronized_with_git?
    exists_on_git? &&                                           # File exists
    git_file.previous_path == git_file.path &&                  # at the same place
    repository.git_sha(git_file.path) == git_file.previous_sha  # with the same content
  end
  
end