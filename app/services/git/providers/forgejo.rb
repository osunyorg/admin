class Git::Providers::Forgejo < Git::Providers::Abstract
  include Git::Providers::Concerns::RestClient

  DEFAULT_ENDPOINT = 'https://codeberg.org/api/v1'.freeze
  COMMIT_BATCH_SIZE = 75

  class InvalidEndpoint < StandardError
    include Git::Providers::Abstract::InvalidEndpoint
  end

  class EndpointUnreachable < StandardError
    include Git::Providers::Abstract::EndpointUnreachable
    include Git::Providers::Abstract::Error
  end

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

  def url
    base_url = endpoint.gsub(%r{/api/v1\z}, '')
    "#{base_url}/#{repository}"
  end

  def create_file(path, content)
    batch << {
      operation: 'create',
      path: path,
      content: Base64.strict_encode64(content)
    }
  end

  def update_file(path, previous_path, content)
    item = tree_item_at_path(previous_path) || tree_item_at_path(path)
    # If the file has been deleted from repository and does not exist anymore, re-create it
    return create_file(path, content) if item.nil?
    operation = {
      operation: 'update',
      path: path,
      content: Base64.strict_encode64(content),
      sha: item.sha
    }
    operation[:from_path] = previous_path if previous_path.present? && previous_path != path
    batch << operation
  end

  def destroy_file(path)
    item = tree_item_at_path(path)
    return if item.nil?
    batch << {
      operation: 'delete',
      path: path,
      sha: item.sha
    }
  end

  def update_theme!
    # Currently, there is no way to update a submodule with forgejo API
    nil
  end

  def init_from_template(name)
    raise NoMethodError, "You must implement the `init_from_template` method in #{self.class.name}"
  end

  def update_secrets(secrets)
    raise NoMethodError, "You must implement the `update_secrets` method in #{self.class.name}"
  end

  def push(commit_message)
    return if batch.empty?
    payload = {
      branch: branch,
      message: commit_message,
      files: batch
    }
    rest_request(:post, "/repos/#{repository}/contents", payload)
    reset_tree_cache!
    true
  end

  def computed_sha(string)
    OpenSSL::Digest::SHA1.hexdigest "blob #{string.bytesize}\x00#{string}"
  end

  def git_sha(path)
    return if path.nil?
    tree_item_at_path(path)&.sha
  end

  def files_in_the_repository
    @files_in_the_repository ||= tree.map(&:path)
  end

  protected

  def check_endpoint!
    json = get('/version')
    raise InvalidEndpoint, "Forgejo endpoint does not point to a valid Forgejo/Gitea instance" unless json.key?('version')
  rescue HTTPError::Unauthorized => e
    raise Unauthorized, e.message
  rescue HTTPError, InvalidResponseError => e
    raise InvalidEndpoint, "Forgejo endpoint does not point to a valid Forgejo/Gitea instance (#{e.message})"
  rescue NetworkError => e
    raise EndpointUnreachable, "Forgejo endpoint is unreachable: #{endpoint} (#{e.message})"
  end

  def check_repository_push_access!
    json = get("/repos/#{repository}")
    unless json.dig('permissions', 'push')
      raise RepositoryForbidden, "Token does not have push access to #{repository}"
    end
  rescue HTTPError::Unauthorized => e
    raise Unauthorized, e.message
  rescue HTTPError::Forbidden => e
    raise RepositoryForbidden, e.message
  rescue HTTPError::NotFound
    raise RepositoryNotFound, "Repository not found on the Forgejo instance"
  rescue NetworkError => e
    raise EndpointUnreachable, "Forgejo endpoint is unreachable: #{endpoint} (#{e.message})"
  end

  def check_branch_push_access!
    target_branch = branch
    json = get("/repos/#{repository}/branches/#{target_branch}")
    unless json['user_can_push']
      raise BranchProtected, "Branch '#{target_branch}' is protected and token cannot push to it"
    end
  rescue HTTPError::NotFound
    raise BranchNotFound, "Branch '#{target_branch}' does not exist in repository #{repository}"
  rescue NetworkError => e
    raise EndpointUnreachable, "Forgejo endpoint is unreachable: #{endpoint} (#{e.message})"
  end

  # Get the complete git tree (paginated by forgejo API)
  def tree
    @tree ||= begin
      items = []
      page = 1
      loop do
        json = get("/repos/#{repository}/git/trees/#{branch}", recursive: true, page: page)
        entries = json['tree'] || []
        items += entries.select { |entry| entry['type'] == 'blob' }.map { |entry| TreeItem.from_json(entry) }
        break unless json['truncated']
        page += 1
      end
      items
    rescue NetworkError
      # A transient network failure mid-pagination should not abort the whole read:
      # degrade gracefully and return whatever page(s) were fetched so far.
      items
    end
  end

  # Required authentication headers for forgejo API requests
  def request_headers
    {
      'Authorization' => "token #{access_token}",
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }
  end
end