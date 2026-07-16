class Git::Providers::Gitlab < Git::Providers::Abstract
  DEFAULT_ENDPOINT = 'https://gitlab.com/api/v4'.freeze
  COMMIT_BATCH_SIZE = 75

  # gitlab allows numerous / in repository names (for groups/sub-groups)
  REPOSITORY_FORMAT = %r{\A[^/\s]+(?:/[^/\s]+)+\z}.freeze

  # tag native gem class with our custom error class
  Gitlab::Error::Error.include Git::Providers::Abstract::Error
  [
    Gitlab::Error::BadRequest,
    Gitlab::Error::Forbidden,
    Gitlab::Error::NotFound,
    Gitlab::Error::MethodNotAllowed,
    Gitlab::Error::NotAcceptable,
    Gitlab::Error::Conflict,
    Gitlab::Error::Unprocessable
  ].each { |klass| klass.include Git::Providers::Abstract::ClientError }


  class Unauthorized < StandardError
    include Git::Providers::Abstract::Unauthorized
  end

  # for generics, no tagging and handle for each context
  class RepositoryNotFound < StandardError
    include Git::Providers::Abstract::RepositoryNotFound
  end

  class BranchNotFound < StandardError
    include Git::Providers::Abstract::BranchNotFound
  end
  class BranchProtected < StandardError
    include Git::Providers::Abstract::BranchProtected
  end
  class RepositoryForbidden < StandardError
    include Git::Providers::Abstract::RepositoryForbidden
  end
  class InvalidEndpoint < StandardError
    include Git::Providers::Abstract::InvalidEndpoint
  end
  class EndpointUnreachable < StandardError
    include Git::Providers::Abstract::EndpointUnreachable
    include Git::Providers::Abstract::Error
  end

  def url
    base_url = endpoint.gsub("/api/v4", "")
    "#{base_url}/#{repository}"
  end

  def create_file(path, content)
    batch << {
      action: 'create',
      file_path: path,
      content: content
    }
  end

  def update_file(path, previous_path, content)
    previous_path_file = tree_item_at_path(previous_path)
    # if the file has been deleted from repository and does not exist anymore, re-create it
    return create_file(path, content) if previous_path_file.nil? && tree_item_at_path(path).nil?
    if previous_path_file.present? && previous_path != path
      batch << {
        action: 'move',
        file_path: path,
        previous_path: previous_path
      }
    end
    batch << {
      action: 'update',
      file_path: path,
      content: content
    }
  end

  def destroy_file(path)
    return if tree_item_at_path(path).nil?
    batch << {
      action: 'delete',
      file_path: path,
    }
  end

  def update_theme!
    return unless should_update_theme?
    client.edit_submodule repository,
                          ENV["GITHUB_WEBSITE_THEME_PATH"],
                          {
                            branch: branch,
                            commit_sha: current_theme_sha,
                            commit_message: theme_update_commit_message
                          }
  end

  def init_from_template(name)
    raise NoMethodError, "You must implement the `init_from_template` method in #{self.class.name}"
  end

  def update_secrets(secrets)
    raise NoMethodError, "You must implement the `update_secrets` method in #{self.class.name}"
  end

  def push(commit_message)
    return if batch.empty?
    client.create_commit  repository,
                          branch,
                          commit_message,
                          batch
    reset_tree_cache!
    true
  end

  def computed_sha(string)
    OpenSSL::Digest::SHA256.hexdigest string
  end

  def git_sha(path)
    return if path.nil?
    tree_item_at_path(path)&.id
  end

  def check_endpoint!
    response = client.get('/version')
    unless response.respond_to?(:version) && response.version.present?
      raise InvalidEndpoint, "Gitlab endpoint does not point to a valid Gitlab instance"
    end
  # Normal without token provided; it is the expected response for a GitLab instance
  rescue Gitlab::Error::Unauthorized, Gitlab::Error::Forbidden
    nil
  # gem raise Gitlab::Error::Parsing if response is not JSON
  rescue Gitlab::Error::ResponseError, Gitlab::Error::Parsing => e
    raise InvalidEndpoint, "Gitlab endpoint does not point to a valid Gitlab instance (#{e.message})"
  # (temporary) network error
  rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT,
    SocketError, Timeout::Error, EOFError => e
    raise EndpointUnreachable, "Gitlab endpoint is unreachable: #{endpoint} (#{e.message})"
  end

  def check_repository_push_access!
    verify_token!
    check_repository_access_for_this_repository!
  end

  def check_branch_push_access!
    # check branch existence
    begin
      client.branch(repository, branch)
    rescue Gitlab::Error::NotFound => e
      raise BranchNotFound.new(e.response_message)
    end
    # Checks that the branch is not protected with a higher access level than the token has
    begin
      protected = client.protected_branch(repository, branch)
      min_push_level = protected.push_access_levels
                                .map(&:access_level)
                                .min || 0
      if token_access_level < min_push_level
        raise BranchProtected, "Branch '#{branch}' is protected and the token's role is not high enough to push to it"
      end
    rescue Gitlab::Error::NotFound
      # No protected branch, all good, nothing to do
    end
  end

  def files_in_the_repository
    @files_in_the_repository ||= tree.map(&:path)
  end

  protected

  def client
    @client ||= Gitlab.client(
      endpoint: endpoint,
      private_token: access_token
    )
  end

  # Invalidates token only if it invalid or expired
  def verify_token!
    token_scopes
  rescue Gitlab::Error::Unauthorized => e
    raise Unauthorized, e.message
  end

  # Check the validity of the token and raise RepositoryForbidden is the gem raise Unauthorized
  def check_repository_access_for_this_repository!
    unless token_scopes.include?('api')
      raise RepositoryForbidden.new('Token must have the "api" scope to push to this repository')
    end
    # 30 = Developer (push), 40 = Maintainer, 50 = Owner
    if token_access_level < 30
      raise RepositoryForbidden.new('Token does not have push access to this repository, role must be at least Developer')
    end
  rescue Gitlab::Error::NotFound => e
    raise RepositoryNotFound.new(e.response_message)
  rescue Gitlab::Error::Unauthorized => e
    raise RepositoryForbidden.new(e.response_message)
  rescue RepositoryForbidden => e
    raise e
  end

  def token_scopes
    @token_scopes ||= client.get('/personal_access_tokens/self').scopes
  end

  def token_access_level
    @token_access_level ||= begin
      project = client.project(repository)
      project_access = project.permissions&.project_access&.access_level
      group_access   = project.permissions&.group_access&.access_level
      project_access || group_access || 0
    end
  end


  def tree
    @tree ||= begin
      items = []
      response = client.tree(repository, ref: branch, recursive: true, per_page: 100)
      items += response.select { |item| item.type == 'blob' }
      while response.has_next_page?
        response = response.next_page
        items += response.select { |item| item.type == 'blob' }
      end
      items
    end
  end

end