# Analyzer est utilisé pour envoyer les fichiers vers les référentiels Git
class Git::Analyzer
  attr_accessor :git_file
  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def should_create?
    !should_destroy? && !exists?(git_file.current_path) && !moved?
  end

  def should_update?
    !should_destroy? && (moved? || different?)
  end

  def should_destroy?
    git_file.current_path.nil?
  end

  protected

  def exists?(path)
    repository.git_sha(path).present?
  end

  def moved?
    (git_file.previous_path != git_file.current_path) && exists?(git_file.previous_path)
  end

  def different?
    git_file.previous_sha != git_file.current_sha
  end
end