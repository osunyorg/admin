# Analyzer est utilisé pour envoyer les fichiers vers les référentiels Git
class Git::Analyzer
  attr_accessor :git_file
  attr_reader :repository

  def initialize(repository)
    @repository = repository
  end

  def should_create?
    !should_destroy? &&
    git_file.previous_path.nil?
  end

  def should_update?
    !should_destroy? &&
    (
      git_file.previous_path != git_file.current_path ||
      git_file.previous_sha != git_file.current_sha
    )
  end

  def should_destroy?
    git_file.will_be_destroyed ||
    git_file.current_path.nil?
  end
end