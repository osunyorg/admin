class Git::Providers::Abstract
  # Marker modules for errors with the same meaning across providers (business logic errors).
  # Each provider includes the matching module in its own error class.
  # Callers can handle every provider with a single check.
  module Error; end
  module ClientError
    include Error
  end
  module InvalidEndpoint; end
  module EndpointUnreachable; end
  module Unauthorized; end
  module RepositoryNotFound; end
  module RepositoryForbidden; end
  module BranchNotFound; end
  module BranchProtected; end
  # GitHub specific, the repository and branch is writable but not under .github/workflow
  # needed by osuny to write Deuxfleurs deployment workflow in the repository
  module WorkflowsForbidden; end

  # Concrete class if format of repository identifier is invalid (local check only)
  class InvalidRepositoryIdentifier < StandardError; end

  # Default repository identifier format (organization/repository, one level only)
  REPOSITORY_FORMAT = %r{\A[^/\s]+/[^/\s]+\z}.freeze
  DEFAULT_BRANCH = 'main'.freeze

  attr_reader :git_repository, :access_token, :repository

  def initialize(git_repository)
    @git_repository = git_repository
    @endpoint = git_repository.website.git_endpoint
    @branch = git_repository.website.git_branch
    @access_token = git_repository.website.access_token
    @repository = git_repository.website.repository
  end

  def endpoint
    @endpoint.presence || self.class::DEFAULT_ENDPOINT
  end

  def branch
    @branch.presence || self.class::DEFAULT_BRANCH
  end

  def check_repository_access!
    check_repository_format!
    check_endpoint!
    return unless access_token.present?
    check_repository_push_access!
    check_branch_push_access!
  rescue Git::Providers::Abstract::Unauthorized => e
    git_repository.website.invalidate_access_token!
    raise e
  end

  # Local check only without querying the provider API
  def check_repository_format!
    return if repository.to_s.match?(self.class::REPOSITORY_FORMAT)
    raise InvalidRepositoryIdentifier, "'#{repository}' is not a valid repository identifier for #{self.class.name.demodulize}"
  end

  def check_endpoint!
    # Some provider may not need an endpoint (GitHub)
  end

  def check_repository_push_access!
    raise NoMethodError, "You must implement `check_repository_push_access!` in #{self.class.name}"
  end

  def check_branch_push_access!
    raise NoMethodError, "You must implement `check_branch_push_access!` in #{self.class.name}"
  end


  def valid?
    repository.present? && access_token.present?
  end

  def url
    raise NoMethodError, "You must implement the `url` method in #{self.class.name}"
  end

  def create_file(path, content)
    raise NoMethodError, "You must implement the `create_file` method in #{self.class.name}"
  end

  def update_file(path, previous_path, content)
    raise NoMethodError, "You must implement the `update_file` method in #{self.class.name}"
  end

  def destroy_file(path)
    raise NoMethodError, "You must implement the `destroy_file` method in #{self.class.name}"
  end

  def update_theme!
    raise NoMethodError, "You must implement the `update_theme!` method in #{self.class.name}"
  end

  def push(commit_message)
    raise NoMethodError, "You must implement the `push` method in #{self.class.name}"
  end

  def computed_sha(string)
    raise NoMethodError, "You must implement the `computed_sha` method in #{self.class.name}"
  end

  def git_sha(path)
    raise NoMethodError, "You must implement the `git_sha` method in #{self.class.name}"
  end

  def files_in_the_repository
    []
  end

  protected

  def batch
    @batch ||= []
  end

  def current_theme_sha
    @current_theme_sha ||= Osuny::ThemeInfo.get_current_sha
  end

  def previous_theme_sha
    @previous_theme_sha ||= git_sha(ENV["GITHUB_WEBSITE_THEME_PATH"])
  end

  def should_update_theme?
    previous_theme_sha != current_theme_sha
  end

  def theme_update_commit_message
    theme_name = ENV["GITHUB_WEBSITE_THEME_REPOSITORY"].to_s.split("/").last
    "Updated #{theme_name} version"
  end

  def tree_item_at_path(path)
    return if path.nil?
    tree_items_by_path[path]
  end

  def tree_items_by_path
    @tree_items_by_path ||= tree.index_by(&:path)
  end

  # To be called after a successful push when the remote repository has changed
  def reset_tree_cache!
    @tree = nil
    @tree_items_by_path = nil
    @files_in_the_repository = nil
  end
end
