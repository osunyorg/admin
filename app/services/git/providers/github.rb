class Git::Providers::Github < Git::Providers::Abstract
  BASE_URL = "https://github.com".freeze
  COMMIT_BATCH_SIZE = 20
  WORKFLOWS_PATH_PREFIX = '.github/workflows/'.freeze

  # same as Octokit::Repository::NAME_WITH_OWNER_PATTERN stricter than our generic one in abstract
  REPOSITORY_FORMAT = %r{\A[\w.-]+/[\w.-]+\z}i.freeze

  include WithSecrets

  # tag native gem class with our custom error class
  Octokit::Error.include Git::Providers::Abstract::Error
  [
    Octokit::BadRequest,
    Octokit::NotFound,
    Octokit::BranchNotProtected,
    Octokit::MethodNotAllowed,
    Octokit::NotAcceptable,
    Octokit::Conflict,
    Octokit::Deprecated,
    Octokit::UnsupportedMediaType,
    Octokit::UnprocessableEntity,
    Octokit::UnavailableForLegalReasons,
    Octokit::TooLargeContent,
    Octokit::RepositoryUnavailable,
    Octokit::UnverifiedEmail,
    Octokit::AccountSuspended,
    Octokit::BillingIssue,
    Octokit::SAMLProtected,
    Octokit::InstallationSuspended
  ].each { |klass| klass.include Git::Providers::Abstract::ClientError }

  class Unauthorized < StandardError
    include Git::Providers::Abstract::Unauthorized
  end

  class RepositoryNotFound < StandardError
    include Git::Providers::Abstract::RepositoryNotFound
  end

  class RepositoryForbidden < StandardError
    include Git::Providers::Abstract::RepositoryForbidden
  end

  class BranchNotFound < StandardError
    include Git::Providers::Abstract::BranchNotFound
  end

  class BranchProtected < StandardError
    include Git::Providers::Abstract::BranchProtected
  end

  class WorkflowsForbidden < StandardError
    include Git::Providers::Abstract::WorkflowsForbidden
  end

  def url
    "#{BASE_URL}/#{repository}"
  end

  def check_repository_push_access!
    repo = client.repository(repository)
    raise RepositoryForbidden, "Token does not have push access to #{repository}" unless repo[:permissions][:push]
  rescue Octokit::Unauthorized => e
    raise Unauthorized, e.message
  rescue Octokit::NotFound => e
    raise RepositoryNotFound, e.message
  rescue Octokit::Forbidden => e
    raise RepositoryForbidden, e.message
  end

  def check_branch_push_access!
    branch_sha
    raise BranchProtected, "Branch is protected and the token cannot push to it" if branch_protected_for_token?
  rescue Octokit::NotFound => e
    raise BranchNotFound, e.message
  end

  def create_file(path, content)
    batch << {
      path: path,
      mode: '100644', # https://docs.github.com/en/rest/reference/git#create-a-tree
      type: 'blob',
      content: content
    }
  end

  def update_file(path, previous_path, content)
    previous_path_file = tree_item_at_path(previous_path)
    new_path_file = tree_item_at_path(path)
    # if the file has been deleted from repository and does not exist anymore, re-create it
    return create_file(path, content) if previous_path_file.nil? && new_path_file.nil?
    if previous_path_file.present?
      # Delete previous file
      batch << {
        path: previous_path,
        mode: previous_path_file[:mode],
        type: previous_path_file[:type],
        sha: nil
      }
      file = previous_path_file
    else
      file = new_path_file
    end
    batch << {
      path: path,
      mode: file[:mode],
      type: file[:type],
      content: content
    }
  end

  def destroy_file(path)
    file = tree_item_at_path(path)
    return if file.nil?
    batch << {
      path: path,
      mode: file[:mode],
      type: file[:type],
      sha: nil
    }
  end

  def update_theme!
    return unless should_update_theme?
    batch << {
      path: ENV["GITHUB_WEBSITE_THEME_PATH"],
      mode: '160000',
      type: 'commit',
      sha: current_theme_sha
    }
    push(theme_update_commit_message)
  end

  def init_from_template(name)
    client.create_repository_from_template(
      ENV['GITHUB_WEBSITE_TEMPLATE_REPOSITORY'],
      name,
      {
        owner: ENV['GITHUB_WEBSITE_OWNER'],
        private: false
      }
    )
  end

  def push(commit_message)
    return if batch.empty?
    commit = create_commit_from_batch(batch, commit_message)
    client.update_branch repository, branch, commit[:sha]
    reset_tree_cache!
    true
  end

  def create_commit_from_batch(batch, commit_message)
    base_tree_sha = tree[:sha]
    base_commit_sha = branch_sha
    commit = nil
    commits_count = (batch.size / COMMIT_BATCH_SIZE.to_f).ceil
    batch.each_slice(COMMIT_BATCH_SIZE).with_index do |sub_batch, i|
      sub_commit_message = commit_message
      sub_commit_message += " (#{i+1}/#{commits_count})" if commits_count > 1
      commit = create_sub_commit(sub_batch, sub_commit_message, base_tree_sha, base_commit_sha)
      base_tree_sha = commit[:tree][:sha]
      base_commit_sha = commit[:sha]
    end
    commit
  end

  def create_sub_commit(sub_batch, sub_commit_message, base_tree_sha, base_commit_sha)
    puts "Creating commit with #{sub_batch.size} files."
    new_tree = client.create_tree repository, sub_batch, base_tree: base_tree_sha
    client.create_commit repository, sub_commit_message, new_tree[:sha], base_commit_sha
  rescue Octokit::Forbidden => e
    raise workflows_forbidden_error(e) if workflows_permission_issue?(sub_batch, e)
    raise e
  end

  # If we need to write to .github/workflows/, needed to write deuxfleurs.yml
  def workflows_permission_issue?(sub_batch, error)
    error.message.include?('Resource not accessible by personal access token') &&
      sub_batch.any? { |entry| entry[:path].to_s.start_with?(WORKFLOWS_PATH_PREFIX) }
  end

  def workflows_forbidden_error(original_error)
    WorkflowsForbidden.new(
      "Token is missing the \"Workflows\" permission required to write under " \
      "#{WORKFLOWS_PATH_PREFIX} (#{original_error.message})"
    )
  end

  def computed_sha(string)
    # Git SHA-1 is calculated from the String "blob <length>\x00<contents>"
    # Source: https://alblue.bandlem.com/2011/08/git-tip-of-week-objects.html
    OpenSSL::Digest::SHA1.hexdigest "blob #{string.bytesize}\x00#{string}"
  end

  def git_sha(path)
    return if path.nil?
    # Try to find in stored tree to avoid multiple queries
    tree_item_at_path(path)&.dig(:sha)
  end

  def files_in_the_repository
    @files_in_the_repository ||= tree[:tree].map { |file| file[:path] }
  end

  protected

  def client
    @client ||= Octokit::Client.new access_token: access_token
  end

  def branch_sha
    @branch_sha ||= begin
      response = client.branch(repository, branch)
      # special case: branch was renamed
      if response[:name] != branch
        raise BranchNotFound, "Branch '#{branch}' no longer exists on GitHub (renamed to '#{response[:name]}')"
      end
      response[:commit][:sha]
    end
  end

  def branch_protected_for_token?
    protection = client.branch_protection(repository, branch)
    return false if protection.nil?
    return true if protection[:required_pull_request_reviews].present?
    restrictions = protection[:restrictions]
    restrictions.present? && restrictions[:users].none? { |user| user[:login] == token_login }
  rescue Octokit::Forbidden
    # can occur if the token does not have permission to access branch protection
    # in that case, we assume the branch is not protected
    false
  end

  def token_login
    @token_login ||= client.user[:login]
  end

  def tree_item_at_path(path)
    tree_items_by_path[path] if tree_items_by_path.has_key? path
  end

  def tree_items_by_path
    unless @tree_items_by_path
      @tree_items_by_path = {}
      tree[:tree].each do |hash|
        path = hash[:path]
        @tree_items_by_path[path] = {
          mode: hash[:mode],
          type: hash[:type],
          sha: hash[:sha]
        }
      end
    end
    @tree_items_by_path
  end

  def tree
    @tree ||= client.tree repository, branch_sha, recursive: true
  end

end
